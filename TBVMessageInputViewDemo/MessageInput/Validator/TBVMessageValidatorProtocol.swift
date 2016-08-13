//
//  TBVMessageValidatorProtocol.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public protocol TBVMessageValidatorHandlerProtocol {
    func handlePublishMessageUnfitWithRecoverHandler(recoverHandler: () -> Void)
}

public protocol TBVMessageValidatorProtocol {
    var validatorHandler: TBVMessageValidatorHandlerProtocol {get set}
    func canPublishMessage(message: String) -> Bool
    func isPublishSign(sign: String) -> Bool
}
