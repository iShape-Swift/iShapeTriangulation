//
//  UniversalSceneState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 30.01.2021.
//  Copyright © 2021 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

final class UniversalSceneState: ObservableObject, Scene {

    private (set) var pageIndex: Int
    
    private let key: String
    private let tests: [UniversalData]
    private var moveIndex: (Int, Int)?
    private var startPosition: Point = .zero
    
    @Published var data: UniversalData
    
    init(key: String, tests: [UniversalData]) {
        self.key = key
        self.tests = tests
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        self.data = self.tests[self.pageIndex]
    }
    
    func onNext() {
        let n = self.tests.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.data = self.tests[self.pageIndex]
    }
    
    func onPrev() {
        let n = self.tests.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.data = self.tests[self.pageIndex]
    }
    
    func onStart(start: CGPoint, radius: CGFloat) -> Bool {
        let ox = Float(start.x)
        let oy = Float(start.y)
        self.moveIndex = nil
        var min = Float(radius * radius)
        let paths = self.data.points
        for i in 0..<paths.count {
            let path = paths[i]
            for j in 0..<path.count {
                let p = path[j]
                let dx = p.x - ox
                let dy = p.y - oy
                let rr = dx * dx + dy * dy
                if rr < min {
                    min = rr
                    self.moveIndex = (i, j)
                    self.startPosition = p
                }
            }
        }
        return self.moveIndex != nil
    }
    
    func onMove(delta: CGSize) {
        guard let index = self.moveIndex else {
            return
        }
        let dx = Float(delta.width)
        let dy = Float(delta.height)
        let p = Point(x: self.startPosition.x - dx, y: self.startPosition.y - dy)
        self.data.points[index.0][index.1] = p
    }
    
    func onEnd(delta: CGSize) {
        self.onMove(delta: delta)
    }
}
