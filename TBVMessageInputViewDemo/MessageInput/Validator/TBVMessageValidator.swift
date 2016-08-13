//
//  TBVMessageValidator.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public class TBVMessageValidator: TBVMessageValidatorProtocol {
    public var validatorHandler: TBVMessageValidatorHandlerProtocol
    
    init(validatorHandler: TBVMessageValidatorHandlerProtocol) {
        self.validatorHandler = validatorHandler
    }
    
    convenience init() {
        self.init(validatorHandler: TBVMessageValidatorHandler())
    }
    
    public func canPublishMessage(message: String) -> Bool {
        return message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count != 0
    }
    
    public func isPublishSign(sign: String) -> Bool {
        return sign == "\n"
    }
}
