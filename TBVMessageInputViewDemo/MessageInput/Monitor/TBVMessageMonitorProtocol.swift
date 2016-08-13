//
//  TBVMessageMonitorProtocol.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/2.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

protocol TBVMessageMonitorProtocol {
    func startMonitor()
    func stopMonitor()
    weak var textView: UIScrollView! {get set}
    init(textView: UIScrollView!)
}
