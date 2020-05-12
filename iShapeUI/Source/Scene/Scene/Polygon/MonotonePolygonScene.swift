//
//  MonotonePolygonScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 29.04.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class MonotonePolygonScene: CoordinateSystemScene {
    
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

        let indices = pShape.delaunay(extraPoints: nil).convexPolygonsIndices

        var i = 0
        while i < indices.count {
            let n = indices[i]
            i += 1
            var polygon = [Point](repeating: .zero, count: n)
            for j in 0..<n {
                let index = indices[j + i]
                polygon[j] = data[index]
            }
            i += n
            
            let shape = ShapeLinePolygon(points: polygon.toCGPoints(), lineWidth: 0.5, color: .init(gray: 0.5, alpha: 1))
            self.addSublayer(shape)
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
            
            self.addSublayer(ShapeVectorPolygon(points: points, shift: -1.0, tip: 1.0, lineWidth: 0.4, color: Colors.master, indexShift: 2.5, data: nil))
            self.addSublayer(ShapeVertexPolygon(points: points, radius: 1, color: dotColor, indexShift: 2.5, data: data))
        }
    }
    
    func showPage(index: Int) {
        self.data = MonotoneTests.data[index]
        self.update()
    }
    
}


extension MonotonePolygonScene: MouseCompatible {
    
    private func findNearest(point: Point, sqrR: Float = 0.5) -> Int? {
        var i = 0
        while i < data.count {
            let p = data[i]
            let dx = p.x - point.x
            let dy = p.y - point.y
            let r = dx * dx + dy * dy
            if r < sqrR {
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
    
    func mouseMove(point: CGPoint) {

    }
    
}

extension MonotonePolygonScene: SceneNavigation {
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
