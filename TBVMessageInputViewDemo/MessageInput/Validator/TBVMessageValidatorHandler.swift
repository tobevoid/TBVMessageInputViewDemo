//
//  TBVMessageValidatorHandler.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageValidatorHandler: TBVMessageValidatorHandlerProtocol {
    func handlePublishMessageUnfitWithRecoverHandler(recoverHandler: () -> Void) {
        let alertController = UIAlertController(title: "不能发送空白消息", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .Default) { _ in
            recoverHandler()
            })
        UIApplication.sharedApplication().topViewController()?.presentViewController(alertController, animated: true, completion: nil)
    }
}