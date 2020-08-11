//
//  InputSystem.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

protocol Keyboard: AnyObject {
    func onKeyDown(keyCode: UInt16) -> Bool
}

final class InputSystem: ObservableObject {

    private final class Subscription {
        weak var ref: Keyboard?
        init(ref: Keyboard) {
            self.ref = ref
        }
    }
    
    private var subscriptions: [Subscription] = []

    func onKeyDown(keyCode: UInt16) -> Bool {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref != nil })
        var result = false
        for subcription in self.subscriptions {
            result = result || (subcription.ref?.onKeyDown(keyCode: keyCode) ?? false)
        }
        return result
    }

    func subscribe(_ object: Keyboard) {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref != nil })
        if !self.subscriptions.contains(where: { $0.ref === object }) {
            self.subscriptions.append(Subscription(ref: object))
        }
    }
    
    func unsubscribe(_ object: Keyboard) {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref !== object && $0.ref != nil })
    }
    
    func unsubscribeAll() {
        assert(Thread.current == Thread.main)
        self.subscriptions = []
    }
    
}
