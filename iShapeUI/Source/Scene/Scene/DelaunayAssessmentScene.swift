//
//  DelaunayAssessmentScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 09/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class DelaunayAssessmentScene: CoordinateSystemScene {
    
    private var pageIndex: Int = 0

    var data = [
        [
          CGPoint(x:-15, y:  0), CGPoint(x:-20, y: -5), CGPoint(x:-25, y:  0), CGPoint(x:-20, y: 10)
        ],
        [
          CGPoint(x: -5, y: 30), CGPoint(x:-10, y: 20), CGPoint(x: -5, y: 10), CGPoint(x:  0, y: 20)
        ],
        [
          CGPoint(x:  5, y:  5), CGPoint(x:  5, y:-10), CGPoint(x: 10, y:-20), CGPoint(x: 10, y: -5)
        ],
        [
          CGPoint(x: -5, y:-20), CGPoint(x:-15, y:-25), CGPoint(x:-20, y:-10), CGPoint(x: -5, y: -15)
        ]
    ]

    private var index: Int?
    private let content = CALayer()

    override init() {
        super.init()
        self.addSublayer(self.content)
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private func update() {
        self.removeAll()
        self.addShapes()
    }
    
    private func removeAll() {
        guard let layers = self.content.sublayers else {
            return
        }

        for layer in layers {
            layer.removeFromSuperlayer()
        }
    }
    
    private func addShapes() {
        
        let n = data.count / 4
        for i in 0..<n {
            let j = 4 * i
            let points = data[pageIndex]
            let a = points[j].point
            let b = points[j + 1].point
            let c = points[j + 2].point
            let p = points[j + 3].point
            
            
            let circle = Delaunay.circumscribedСircleCenter(a: a, b: b, c: c)
            
            self.content.addSublayer(ShapeCircle(position: circle.center.toCGPoint, radius: CGFloat(circle.radius), color: Colors.lightGray, depth: 0.4))
            
            let iCircle = Delaunay.inscribedСircle(a: a, b: b, c: c)
            
            self.content.addSublayer(ShapeCircle(position: iCircle.center.toCGPoint, radius: CGFloat(iCircle.radius), color: Colors.blue, depth: 0.4))

            let ai = IntGeom.defGeom.int(point: a)
            let bi = IntGeom.defGeom.int(point: b)
            let ci = IntGeom.defGeom.int(point: c)
            let pi = IntGeom.defGeom.int(point: p)
            
            let success = Delaunay.verefy(p: pi, a: ai, b: bi, c: ci)
            
            let color: CGColor
            
            if success {
                color = Colors.darkGreen
                self.content.addSublayer(ShapeLine(start: a.toCGPoint, end: c.toCGPoint, lineWidth: 0.4, strokeColor: color))
            } else {
                color = Colors.red
                self.content.addSublayer(ShapeLine(start: b.toCGPoint, end: p.toCGPoint, lineWidth: 0.4, strokeColor: color))
            }
            
            let info = ["a", "b", "c", "p"]
            
            self.content.addSublayer(ShapeVectorPolygon(points: [a, b, c, p].toCGPoints() , shift: 0.0, tip: 0.0, lineWidth: 0.4, color: color, indexShift: -2.5, data: info))
        }
    }
    
}


extension DelaunayAssessmentScene: MouseCompatible {
    
    private func findNearest(point: CGPoint) -> Int? {
        var i = 0
        while i < data.count {
            let p = data[pageIndex][i]
            let dx = p.x - point.x
            let dy = p.y - point.y
            let r = dx * dx + dy * dy
            if r < 0.5 {
                return i
            }
            
            i += 1
        }
        
        return nil
    }
    
    func mouseDown(point: CGPoint) {
        self.index = findNearest(point: point)
    }

    func mouseUp(point: CGPoint) {
        self.index = nil
    }
    
    func mouseDragged(point: CGPoint) {
        guard let index = self.index else {
            return
        }
        
        let x = CGFloat(Int(point.x * 2)) / 2
        let y = CGFloat(Int(point.y * 2)) / 2
        
        let point = CGPoint(x: x, y: y)
        let prevPoint = data[pageIndex][index]
        if point != prevPoint {
            data[pageIndex][index] = point
            self.update()
        }
    }

}

extension DelaunayAssessmentScene: SceneNavigation {
    
    func next() {
        self.pageIndex = (self.pageIndex + 1) % self.data.count
        self.update()
    }
    
    func back() {
        self.pageIndex = (self.pageIndex - 1 + self.data.count) % self.data.count
        self.update()
    }
    
    func getName() -> String {
        return "test \(self.pageIndex)"
    }
}
