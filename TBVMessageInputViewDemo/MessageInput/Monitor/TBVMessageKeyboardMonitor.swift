//
//  TBVMessageKeyboardMonitor.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

protocol TBVMessageKeyboardMonitorDelegete: NSObjectProtocol {
    func messageKeyboardMonitor(monitor: TBVMessageKeyboardMonitor, willChangeFrame frame: CGRect, animationDuration duration: NSTimeInterval)
}

public class TBVMessageKeyboardMonitor: NSObject, TBVMessageMonitorProtocol {
    public var keyboardFrame = CGRect()
    public var animationDuration = NSTimeInterval()
    weak var delegate: TBVMessageKeyboardMonitorDelegete?
    
    weak var textView: UIScrollView!
    
    required public init(textView: UIScrollView!) {
        self.textView = textView
    }
    
    public func startMonitor() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    public func stopMonitor() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        /* 保存keyboard高度，注意是UIKeyboardFrameEndUserInfoKey，不是UIKeyboardFrameBeginUserInfoKey */
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            debugPrint(keyboardFrame, #function, UIApplication.sharedApplication().applicationState.rawValue)
            /* 要注意的是，系统中的App可能共用一个keyboard，所以在其他App中打开keyboard，会对自己的App造成影响
             * 所以如果不是Active的话，就不改变y坐标值
             * 但是进入前台后，keyboard的坐标还是会发生若干次改变
             * 所以最好还是记录resignActive时的环境，然后在becomeActive后，延迟若干时间，恢复环境
             * 由于是较为罕见情况，所以不做这种处理
             * 后面判断是防止从后台一进入前台，状态还未更改为Active，但是已经可以响应事件点击了，造成坐标显示不正确的情况
             * 一旦textView成为第一响应者，就允许改变y坐标
             * 不过这样做切换App时会有Snapshotting a view that has not been rendered...警告，不过不影响使用
             */
            /* 系统消息的输入框也没有对这些情况进行处理，所以可以注释掉下面判断 */
//            guard UIApplication.sharedApplication().applicationState == .Active ||
//                textView.isFirstResponder() else { return }
            self.keyboardFrame = keyboardFrame
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.floatValue {
                self.animationDuration = NSTimeInterval(animationDuration)
                
                delegate?.messageKeyboardMonitor(self, willChangeFrame: keyboardFrame, animationDuration: NSTimeInterval(animationDuration))
            }
        }
    }
}
