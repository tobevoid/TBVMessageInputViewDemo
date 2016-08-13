//
//  TBVMessageInputCoreView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public protocol TBVMessageInputCoreViewDelegate: NSObjectProtocol {
    func coreViewDidBecomeActive(coreView: TBVMessageInputCoreView)
    func coreViewDidClickSendMessage(coreView: TBVMessageInputCoreView)
    func coreView(coreView: TBVMessageInputCoreView, didChangeText text: String)
}

public protocol TBVMessageInputCoreViewLayoutDataSource: NSObjectProtocol {
    func coreViewActionForHeightChange(coreView: TBVMessageInputCoreView) -> (() -> Void)?
}

private let kTBVMessageInputCoreContentInset = UIEdgeInsets(top: 9, left: 5, bottom: 9, right: 5)
private let kTBVMessageInputCoreChangeHeightAnimateDuration = NSTimeInterval(0.25)
private let kTBVMessageInputCoreMaxInputViewHeight      = CGFloat(100.0)
private let kTBVMessageInputCoreOriginTextViewHeight    = CGFloat(33.0)
private let kTBVMessageInputCoreOriginInputViewHeight   = CGFloat(50.0)

// MARK: 不能针对此控件的父控件使用自动布局
public class TBVMessageInputCoreView: UIView {
    // MARK:  private property
    lazy var textView: TBVPlaceholderTextView = {
        let textView = TBVPlaceholderTextView(frame: .zero)
        textView.layer.cornerRadius = 5.0
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        textView.returnKeyType = .Send
        textView.textColor = UIColor.blackColor()
        textView.enablesReturnKeyAutomatically = true
        textView.delegate = self
        return textView
    }()
    private lazy var keyboardMonitor: TBVMessageKeyboardMonitor = {
        let keyboardMonitor = TBVMessageKeyboardMonitor(textView: self.textView)
        keyboardMonitor.delegate = self
        return keyboardMonitor
    }()
    private lazy var textViewMonitor: TBVMessageTextViewMonitor = {
        let textViewMonitor = TBVMessageTextViewMonitor(textView: self.textView)
        textViewMonitor.delegate = self
        return textViewMonitor
    }()
    private var host: UIView!
    public var originTextViewHeight = kTBVMessageInputCoreOriginTextViewHeight
    
    // MARK:  public property
    public var contentInset = kTBVMessageInputCoreContentInset {
        didSet {
            originTextViewHeight = originInputViewHeight - contentInset.top - contentInset.bottom
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    public var maxInputViewHeight = kTBVMessageInputCoreMaxInputViewHeight
    public var originInputViewHeight = kTBVMessageInputCoreOriginInputViewHeight {
        didSet {
            originTextViewHeight = originInputViewHeight - contentInset.top - contentInset.bottom
        }
    }
    public var changeHeightAnimateDuration = kTBVMessageInputCoreChangeHeightAnimateDuration
    public weak var delegete: TBVMessageInputCoreViewDelegate?
    public weak var dataSource: TBVMessageInputCoreViewLayoutDataSource?
    public var messageValidator: TBVMessageValidatorProtocol = TBVMessageValidator()
    
    // MARK:  life cycle
    public init(frame: CGRect, host: UIView!) {
        self.host = host
        super.init(frame: frame)
        addSubview(textView)
        textViewMonitor.startMonitor()
        keyboardMonitor.startMonitor()
    }
    
    convenience init(host: UIView!) {
        self.init(frame: .zero, host: host)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        textViewMonitor.stopMonitor()
        keyboardMonitor.stopMonitor()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK:  layout
    public override func willMoveToWindow(newWindow: UIWindow?) {
        superview?.willMoveToWindow(window)
        textView.frame.size.height = frame.size.height - contentInset.top - contentInset.bottom
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame.size.width = frame.size.width - contentInset.left - contentInset.right
        textView.frame.origin.x = contentInset.left
        textView.frame.origin.y = contentInset.top
    }
    
    // MARK:  publish
    private func publishMessage() {
        if !messageValidator.canPublishMessage(textView.text) {
            textView.resignFirstResponder()
            messageValidator.validatorHandler.handlePublishMessageUnfitWithRecoverHandler {
                self.textView.becomeFirstResponder()
            }
        } else {
            delegete?.coreViewDidClickSendMessage(self)
            textView.clearText()
        }
    }
}


// MARK:  TBVMessageKeyboardMonitorDelegete
extension TBVMessageInputCoreView: TBVMessageKeyboardMonitorDelegete {
    func messageKeyboardMonitor(monitor: TBVMessageKeyboardMonitor, willChangeFrame frame: CGRect, animationDuration duration: NSTimeInterval) {
        debugPrint(frame, UIApplication.sharedApplication().applicationState.rawValue)
        /* 当所在视图被push的时候，keyboard会缩回去，pop回来的时候会有一个不想要的动画效果
         * 所以判断当前viewController是否是顶层控制器
         */
        guard UIApplication.sharedApplication().topViewController() == viewController else { return }
        
        UIView.animateWithDuration(NSTimeInterval(duration)) {
            self.host.frame.origin.y = frame.origin.y - self.host.frame.height
        }
        /* 因为不能针对父控件使用自动布局，所以如果要横屏，那么需要手动监听屏幕旋转，更改坐标 */
    }
}

// MARK:  TBVMessageInputCoreViewMonitorDelegete
extension TBVMessageInputCoreView: TBVMessageTextViewMonitorDelegete {
    public func messageTextViewMonitor(monitor: TBVMessageTextViewMonitor, didChangeContentSize contentSize: CGSize) {
        let textViewHeight = max(originTextViewHeight, min(contentSize.height, maxInputViewHeight))
        let inputViewHeight = originInputViewHeight + textViewHeight - originTextViewHeight
        debugPrint(contentSize)
        /* 这个地方会频繁调用，最佳操作为更改frame中涉及到的个别成员
         * 频繁调用layoutSubviews做动画，会造成子控件内容抖动(特别是UITextView)
         * 也是因为这个，造成coreView的父控件不能频繁地调用layeoutIfNeeded
         * 也就是说，不能针对父控件使用自动布局
         */
        UIView.animateWithDuration(changeHeightAnimateDuration, animations: {
            self.host.frame.size.height = inputViewHeight
            /* 键盘未弹出前，keyboardFrame为0，需要过滤这部分操作 */
            if self.keyboardMonitor.keyboardFrame.origin.y != 0 {
                self.host.frame.origin.y = self.keyboardMonitor.keyboardFrame.origin.y - inputViewHeight
            }
            self.textView.frame.size.height = self.host.frame.size.height - self.contentInset.bottom - self.contentInset.top
            self.dataSource?.coreViewActionForHeightChange(self)?()
        })
    }
}


// MARK:  UITextViewDelegate
extension TBVMessageInputCoreView: UITextViewDelegate {
    public func textViewDidChange(textView: UITextView) {
        delegete?.coreView(self, didChangeText: textView.text)
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        delegete?.coreViewDidBecomeActive(self)
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let isPublishSign = messageValidator.isPublishSign(text)
        if isPublishSign {
            publishMessage()
        }
        return !isPublishSign
    }
}
