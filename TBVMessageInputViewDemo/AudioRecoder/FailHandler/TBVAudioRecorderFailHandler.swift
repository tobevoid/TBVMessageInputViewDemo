//
//  TBVAudioRecorderFailHandler.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/6.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVAudioRecorderFailHandler: TBVAudioRecorderFailHandlerProtocol {
    func failToRecodHandler() {
        showAlertWithTitle("录音失败", message: "出现未知错误，请重新录制", comfirmTitle: "好")
    }
    
    func forbidToAccessRecorderHandler() {
        showAlertWithTitle("无法录音", message: "请在iPhone的\"设置-隐私-麦克风\"选项中，允许乔布简历访问你的手机麦克风。", comfirmTitle: "好")
    }
    
    private func showAlertWithTitle(title: String, message: String, comfirmTitle: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if let comfirmTitle = comfirmTitle {
            alertController.addAction(UIAlertAction(title: comfirmTitle, style: .Default, handler: nil))
        }
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}
