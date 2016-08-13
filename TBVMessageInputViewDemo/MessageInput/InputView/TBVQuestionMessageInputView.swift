//
//  TBVQuestionMessageInputView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit
import SnapKit

enum TBVQuestionMessagePlaceholderType: String {
    case Question   = "请输入你的问题"
    case Common     = "发布问题记得要勾选提问哦~"
}

public class TBVQuestionMessageInputView: TBVMessageInputView, TBVMessageInputViewProtocol {
    lazy public var inputCoreView: TBVMessageInputCoreView = {
        let inputCoreView = TBVMessageInputCoreView(host: self)
        inputCoreView.dataSource = self
        inputCoreView.textView.placeholder = TBVQuestionMessagePlaceholderType.Common.rawValue
        return inputCoreView
    }()
    
    lazy var qustionView: TBVMessageQuestionView = {
        let questionView = TBVMessageQuestionView()
        questionView.delegate = self
        return questionView
    }()
    
    // MARK:  life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(inputCoreView)
        addSubview(qustionView)
        layoutPageSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  layout
    internal override func layoutPageSubviews() {
        qustionView.snp_makeConstraints { (make) in
            make.left.top.height.equalTo(self)
            make.width.equalTo(80.0)
        }
        
        inputCoreView.snp_makeConstraints { (make) in
            make.left.equalTo(qustionView.snp_right)
            make.right.height.top.equalTo(self)
        }
    }
}

// MARK: - TBVMessageInputCoreViewLayoutDataSource
extension TBVQuestionMessageInputView: TBVMessageInputCoreViewLayoutDataSource {
    public func coreViewActionForHeightChange(coreView: TBVMessageInputCoreView) -> (() -> Void)? {
        return {
            /* 这里不能调用self.layoutIfNeeded()，否则textView内容会抖动 */
            self.qustionView.layoutIfNeeded()
        }
    }
}

// MARK: - TBVMessageQuestionViewDelegate
extension TBVQuestionMessageInputView: TBVMessageQuestionViewDelegate {
    func messageQuestionView(questionView: TBVMessageQuestionView, didClickAskButtonWithIsQuestioning isQuestioning: Bool) {
        var placeholder: String
        if isQuestioning {
            inputCoreView.textView.becomeFirstResponder()
            placeholder = TBVQuestionMessagePlaceholderType.Question.rawValue
        } else {
            placeholder = TBVQuestionMessagePlaceholderType.Common.rawValue
        }
        inputCoreView.textView.placeholder = placeholder
    }
}