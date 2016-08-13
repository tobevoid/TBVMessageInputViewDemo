//
//  ViewController.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit


class ViewController: UIViewController, TBVMessageInputCoreViewDelegate {
    private lazy var messageInputView: TBVAudioMessageInputView = {
        let inputView = TBVAudioMessageInputView()
        inputView.inputCoreView.delegete = self
        return inputView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageInputView)
        
        messageInputView.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageInputView.frame.size.width = view.frame.width
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func coreViewDidBecomeActive(coreView: TBVMessageInputCoreView) {
        debugPrint(#function)
    }
    
    func coreView(coreView: TBVMessageInputCoreView, didChangeText text: String) {
        debugPrint(text)
    }
    
    func coreViewDidClickSendMessage(coreView: TBVMessageInputCoreView) {
        debugPrint(#function)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        messageInputView.endEditing(true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }
}

