//
//  SplitScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class SplitScene: CoordinateSystemScene {

    private var pageIndex: Int = 2
    private var data: [[Point]] = []
    private var aIndex: ActiveIndex?

    override init() {
        super.init()
        self.showPage(index: pageIndex)
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
        guard let layers = self.sublayers else {
            return
        }
        for layer in layers {
            if !(layer is ShapeCoordinatSystem || layer is ShapeLine) {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    private func addShapes() {
        let iGeom = IntGeom()
        
        let shape = self.getShape()
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)

        let debugShapes = pShape.split().shapes
        
        for i in 0..<debugShapes.count {
            let shape = debugShapes[i]
            let color = Colors.getColor(index: i).cgColor
            let points = iGeom.float(points: shape.points).toCGPoints()
            self.addSublayer(ShapeVectorPolygon(points: points, shift: 0.5, tip: 1.0, lineWidth: 0.4, color: color, indexShift: 2.5, data: nil))
        }
        
        let pathes = pShape.pathes

        for vertices in pathes {
            var points = [CGPoint]()
            points.reserveCapacity(vertices.count)
            
            var data = [String]()
            data.reserveCapacity(vertices.count)
            
            for i in 0..<vertices.count {
                let vertex = vertices[i]
                data.append(String(vertex.index))
                points.append(iGeom.float(point: vertex.point).toCGPoint)
            }
            
            let dotColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            self.addSublayer(ShapeVertexPolygon(points: points, radius: 1, color: dotColor, indexShift: 2.5, data: data))
        }

    }
    
    func showPage(index: Int) {
        self.data = MonotoneSplitTests.data[index]
        self.update()
    }
    
}

extension SplitScene: MouseCompatible {

    private func findNearest(point: Point) -> ActiveIndex? {
        var j = 0
        while j < data.count {
            var i = 0
            let points = data[j]
            while i < points.count {
                let p = points[i]
                let dx = p.x - point.x
                let dy = p.y - point.y
                let r = dx * dx + dy * dy
                if r < 0.5 {
                    return ActiveIndex(i: i, j: j)
                }
                
                i += 1
            }
            j += 1
        }

        return nil
    }

    func mouseDown(point: CGPoint) {
        self.aIndex = findNearest(point: point.point)
    }
    
    
    func mouseUp(point: CGPoint) {
        self.aIndex = nil
    }
    
    
    func mouseDragged(point: CGPoint) {
        guard let index = self.aIndex else {
            return
        }
        
        let x = Float(Int(point.x * 2)) / 2
        let y = Float(Int(point.y * 2)) / 2
        
        let point = Point(x: x, y: y)
        let prevPoint = data[index.j][index.i]
        if point != prevPoint {
            data[index.j][index.i] = point
            self.update()
        }
    }
    
    private func getShape() -> Shape {
        let hull = data[0]
        var holes = data
        holes.remove(at: 0)
        return Shape(hull: hull, holes: holes)
    }
    
}

extension SplitScene: SceneNavigation {
    func next() {
        let n = MonotoneSplitTests.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        self.showPage(index: self.pageIndex)
    }
    
    func back() {
        let n = MonotoneSplitTests.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        self.showPage(index: self.pageIndex)
    }
    
    func getName() -> String {
        return "test \(self.pageIndex)"
    }
}

