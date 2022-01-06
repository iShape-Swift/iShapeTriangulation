//
//  Scene.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import Foundation

protocol Scene: Keyboard {
    var pageIndex: Int { get }
    func onNext()
    func onPrev()
    func onStart(start: CGPoint, radius: CGFloat) -> Bool
    func onMove(delta: CGSize)
    func onEnd(delta: CGSize)
}

extension Scene {
    func onKeyDown(keyCode: UInt16) -> Bool {
        if keyCode == 124 || keyCode == 49 || keyCode == 36 {
            self.onNext()
            return true
        } else if keyCode == 123 {
            self.onPrev()
            return true
        } else {
            return false
        }
    }
}
