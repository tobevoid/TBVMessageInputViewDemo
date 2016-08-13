//
//  UIView+Controller.swift
//
//  Created by tripleCC on 16/5/26.
//  Copyright © 2016年 chengfj. All rights reserved.
//

import UIKit

extension UIView {
    var viewController: UIViewController? {
        get {
            var view: UIView? = self
            repeat {
                let nextResponder = view?.nextResponder()
                if let VC = nextResponder as? UIViewController {
                    return VC
                }
                view = view?.superview
            } while view != nil
            return nil
        }
    }
    
    func pushController(controller:UIViewController, animated: Bool) {
        if let _ = viewController?.navigationController?.parentViewController as? UITabBarController {
            viewController?.hidesBottomBarWhenPushed = true
        }
        viewController?.navigationController?.pushViewController(controller, animated: animated)
        if viewController?.navigationController?.childViewControllers.count == 2 {
            viewController?.hidesBottomBarWhenPushed = false
        }
    }
}