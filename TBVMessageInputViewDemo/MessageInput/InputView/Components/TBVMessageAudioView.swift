//
//  TBVAudioInputView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

protocol TBVMessageAudioViewDelegate: NSObjectProtocol {
    func messageAudioView(audioView: TBVMessageAudioView, didChangeInputType inputType: TBVMessageAudioInputType)
}

enum TBVMessageAudioInputType {
    case Keyboard
    case Audio
}

class TBVMessageAudioView: UIView {
    private lazy var inputTypeButton: UIButton = {
        let inputTypeButton = UIButton(type: .Custom)
        inputTypeButton.imageView?.contentMode      = .ScaleAspectFit
        inputTypeButton.adjustsImageWhenHighlighted = false
        inputTypeButton.setImage(UIImage(named: "message_input_keyboard"), forState: .Normal)
        inputTypeButton.setImage(UIImage(named: "message_input_audio"), forState: .Selected)
        inputTypeButton.addTarget(self, action: #selector(audioButtonOnClicked), forControlEvents: .TouchDown)
        return inputTypeButton
    }()
    var inputType: TBVMessageAudioInputType = .Keyboard
    weak var delegate: TBVMessageAudioViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inputTypeButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layoutPageSubviews() {
        inputTypeButton.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

extension TBVMessageAudioView {
    func audioButtonOnClicked(button: UIButton) {
        button.selected = !button.selected
        inputType = button.selected ? .Audio : .Keyboard
        delegate?.messageAudioView(self, didChangeInputType: inputType)
    }
}