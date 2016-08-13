//
//  TBVProperty.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/8.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import Foundation

public struct TBVProperty <U> {
    private var value_: U
    public var value: U {
        get {
            return value_
        }
        set {
            value_ = newValue
        }
    }
}

public struct TBVSafeProperty <U> {
    public var lock: AnyObject!
    
    public var value: U
    public var safeValue: U {
        get {
            return withLock {
                return value
            }
        }
        set {
            withLock {
                value = newValue
            }
        }
    }
    
    /* 不可与safeValue混用 */
    public func sync_enter() {
        objc_sync_enter(lock)
    }
    
    public func sync_exit() {
        objc_sync_exit(lock)
    }
    
    private func withLock<R>(@noescape action: () -> R) -> R {
        objc_sync_enter(lock)
        let result = action()
        objc_sync_exit(lock)
        return result
    }
}