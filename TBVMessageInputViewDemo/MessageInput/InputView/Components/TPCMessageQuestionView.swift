//
//  TBVQustionInputView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

protocol TBVMessageQuestionViewDelegate: NSObjectProtocol {
    func messageQuestionView(questionView: TBVMessageQuestionView, didClickAskButtonWithIsQuestioning isQuestioning: Bool)
}

private let kTBVMessageQuestionAskButtonSize = CGSize(width: 25.0, height: 25.0)
private let kTBVMessageQuestionPointViewSize = CGSize(width: 15.0, height: 15.0)
private let kTBVMessageQuestionAskButtonExpandMargin    = CGFloat(8.0)
private let kTBVMessageQuestionPointViewAnimateDuration = NSTimeInterval(0.15)

class TBVMessageQuestionView: UIView {
    private lazy var askButton: UIButton = {
        let askButton = UIButton(type: .Custom)
        askButton.addTarget(self, action: #selector(askButtonOnClicked), forControlEvents: .TouchDown)
        askButton.layer.borderColor     = UIColor.lightGrayColor().CGColor
        askButton.layer.borderWidth     = 1.0
        askButton.layer.cornerRadius    = 5.0
        return askButton
    }()
    
    private lazy var askLabel: UILabel = {
        let askLabel        = UILabel()
        askLabel.font       = UIFont.systemFontOfSize(16.0)
        askLabel.textColor  = UIColor.grayColor()
        askLabel.text       = "提问"
        return askLabel
    }()
    
    private lazy var pointView: UIView = {
        let pointView = UIView()
        pointView.backgroundColor           = UIColor.blueColor()
        pointView.layer.cornerRadius        = 2.0
        pointView.userInteractionEnabled    = false
        return pointView
    }()
    
    var isQuestioning = Bool(false)
    weak var delegate: TBVMessageQuestionViewDelegate?
    // MARK:  life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(askButton)
        addSubview(askLabel)
        addSubview(pointView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  layout 
    private func layoutPageSubviews() {
        askButton.snp_makeConstraints { (make) in
            make.left.equalTo(15.0)
            make.centerY.equalTo(snp_centerY)
            make.size.equalTo(kTBVMessageQuestionAskButtonSize)
        }
        askLabel.snp_makeConstraints { (make) in
            make.left.equalTo(askButton.snp_right).offset(5.0)
            make.centerY.equalTo(askButton)
        }
        pointView.snp_makeConstraints { (make) in
            make.center.equalTo(askButton)
            make.size.equalTo(CGSize.zero)
        }
    }
    
    // MARK:  event chain
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let expandMargin = kTBVMessageQuestionAskButtonExpandMargin
        var targetFrame = CGRect()
        targetFrame.origin.x    = askButton.frame.origin.x - expandMargin
        targetFrame.origin.y    = askButton.frame.origin.y - expandMargin
        targetFrame.size.width  = askButton.frame.size.width + 2 * expandMargin
        targetFrame.size.height = askButton.frame.size.height + 2 * expandMargin
        if CGRectContainsPoint(targetFrame, point) {
            return askButton
        } else {
            return super.hitTest(point, withEvent: event)
        }
    }
}


// MARK: - event response
extension TBVMessageQuestionView {
    func askButtonOnClicked(button: UIButton) {
        isQuestioning = !isQuestioning
        let pointViewSize = isQuestioning ? kTBVMessageQuestionPointViewSize : CGSize.zero
        pointView.snp_updateConstraints { (make) in
            make.size.equalTo(pointViewSize)
        }
        UIView.animateWithDuration(kTBVMessageQuestionPointViewAnimateDuration) {
            self.layoutIfNeeded()
        }
        delegate?.messageQuestionView(self, didClickAskButtonWithIsQuestioning: isQuestioning)
    }
}
