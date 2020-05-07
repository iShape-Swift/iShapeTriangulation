//
//  MotonePlainScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 06/08/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class MotonePlainScene: CoordinateSystemScene {

    private var data: [Point] = []
    private var index: Int?
    
    override init() {
        super.init()
        self.showPage(index: MonotoneTests.pageIndex)
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

        var info = [String]()
        info.reserveCapacity(data.count)
        for i in 0..<data.count {
           info.append(String(i))
        }

        let iPoints = iGeom.int(points: data)

        let iShape = IntShape(hull: iPoints, holes: [])
        let pShape = PlainShape(iShape: iShape)

        let triangles = pShape.triangulate()
        
        var triangle = [Int]()
        var k = 0
        for i in triangles {
            triangle.append(i)
            if triangle.count == 3 {
                let cgPoints = triangle.map({ self.data[$0] }).toCGPoints()
                let shapeTriangle = ShapeTriangle(points: cgPoints, text: String(k), color: Colors.lightGray)
                self.addSublayer(shapeTriangle)
                triangle.removeAll()
                k += 1
            }
        }

        let color: CGColor
        let isValid = iPoints.isMonotone
        if isValid {
            color = Colors.master
        } else {
            color = Colors.lightGray
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
            
            self.addSublayer(ShapeVectorPolygon(points: points, shift: -1.0, tip: 1.0, lineWidth: 0.4, color: color, indexShift: 2.5, data: nil))
            self.addSublayer(ShapeVertexPolygon(points: points, radius: 1, color: dotColor, indexShift: 2.5, data: data))
        }
   }
    
    func showPage(index: Int) {
        self.data = MonotoneTests.data[index]
        self.update()
    }
    
}


extension MotonePlainScene: MouseCompatible {
    
    private func findNearest(point: Point) -> Int? {
        var i = 0
        while i < data.count {
            let p = data[i]
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
        self.index = findNearest(point: point.point)
    }
    
    
    func mouseUp(point: CGPoint) {
        self.index = nil
    }
    
    
    func mouseDragged(point: CGPoint) {
        guard let index = self.index else {
            return
        }
        
        let x = Float(Int(point.x * 2)) / 2
        let y = Float(Int(point.y * 2)) / 2
        
        let point = Point(x: x, y: y)
        let prevPoint = data[index]
        if point != prevPoint {
            data[index] = point
            self.update()
        }
    }
    
}

extension MotonePlainScene: SceneNavigation {
    func next() {
        self.showPage(index: MonotoneTests.nextIndex())
    }
    
    func back() {
        self.showPage(index: MonotoneTests.prevIndex())
    }
    
    func getName() -> String {
        return "test \(MonotoneTests.pageIndex)"
    }
}
