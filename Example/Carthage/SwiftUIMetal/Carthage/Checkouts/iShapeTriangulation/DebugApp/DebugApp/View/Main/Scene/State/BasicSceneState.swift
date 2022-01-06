//
//  BasicSceneState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//


import SwiftUI
import iGeometry
import iShapeTriangulation

final class BasicSceneState: ObservableObject, Scene {

    private (set) var pageIndex: Int
    private let key: String
    private let data: [[Point]]
    private var moveIndex: Int?
    private var startPosition: Point = .zero
    
    @Published var points: [Point] = []
    
    init(key: String, data: [[Point]]) {
        self.key = key
        self.data = data
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        self.points = self.data[self.pageIndex]
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex]
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex]
    }
    
    func onStart(start: CGPoint, radius: CGFloat) -> Bool {
        let ox = Float(start.x)
        let oy = Float(start.y)
        self.moveIndex = nil
        var min = Float(radius * radius)
        for i in 0..<self.points.count {
            let p = self.points[i]
            let dx = p.x - ox
            let dy = p.y - oy
            let rr = dx * dx + dy * dy
            if rr < min {
                min = rr
                self.moveIndex = i
                self.startPosition = p
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
        self.points[index] = Point(x: self.startPosition.x - dx, y: self.startPosition.y - dy)
    }
    
    func onEnd(delta: CGSize) {
        self.onMove(delta: delta)
    }
}

