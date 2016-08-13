//
//  TBVMessageTextViewMonitor.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/2.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public protocol TBVMessageTextViewMonitorDelegete: NSObjectProtocol {
    func messageTextViewMonitor(monitor:TBVMessageTextViewMonitor, didChangeContentSize contentSize: CGSize)
}

public class TBVMessageTextViewMonitor: NSObject, TBVMessageMonitorProtocol {
    weak var delegate: TBVMessageTextViewMonitorDelegete?
    weak var textView: UIScrollView!
    private var hasAddedObserver = false
    
    required public init(textView: UIScrollView!) {
        self.textView = textView
    }
    public func startMonitor() {
        guard !hasAddedObserver else { return }
        textView.addObserver(self, forKeyPath: "contentSize", options: [.New, .Old], context: nil)
    }
    
    public func stopMonitor() {
        guard hasAddedObserver else { return }
       textView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyPath = keyPath,
            let object = object as? TBVPlaceholderTextView {
            if keyPath == "contentSize" && object == textView {
                delegate?.messageTextViewMonitor(self, didChangeContentSize: textView.contentSize)
            }
        }
    }

}