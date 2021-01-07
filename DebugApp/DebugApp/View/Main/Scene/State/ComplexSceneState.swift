//
//  ComplexSceneState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

final class ComplexSceneState: ObservableObject, Scene {
    
    private let key: String
    private let data: [[[Point]]]
    private var pageIndex: Int
    private var moveIndex: (Int, Int)?
    private var startPosition: Point = .zero
    
    @Published var paths: [[Point]]
    
    init(key: String, data: [[[Point]]]) {
        self.key = key
        self.data = data
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        self.paths = self.data[self.pageIndex]
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.paths = self.data[self.pageIndex]
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.paths = self.data[self.pageIndex]
    }
    
    func onStart(start: CGPoint, radius: CGFloat) -> Bool {
        let ox = Float(start.x)
        let oy = Float(start.y)
        self.moveIndex = nil
        var min = Float(radius * radius)
        for i in 0..<self.paths.count {
            let path = self.paths[i]
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
        self.paths[index.0][index.1] = p
    }
    
    func onEnd(delta: CGSize) {
        self.onMove(delta: delta)
    }
}
