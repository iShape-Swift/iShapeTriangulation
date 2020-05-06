//
//  ComplexPolygonScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 29.04.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class ComplexPolygonScene: CoordinateSystemScene {

    private var pageIndex: Int = UserDefaults.standard.integer(forKey: "complex")
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

        let indices = pShape.convexPolygons()
        let shapePoints = iGeom.float(points: pShape.points).toCGPoints()
        
        
        var i = 0
        while i < indices.count {
            let n = indices[i]
            i += 1
            var polygon = [CGPoint](repeating: .zero, count: n)
            for j in 0..<n {
                let index = indices[j + i]
                polygon[j] = shapePoints[index]
            }
            i += n
            
            let shape = ShapeLinePolygon(points: polygon, lineWidth: 0.5, color: .init(gray: 0.5, alpha: 1))
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
        self.data = ComplexTests.data[index]
        self.update()
    }
    
}

extension ComplexPolygonScene: MouseCompatible {

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

extension ComplexPolygonScene: SceneNavigation {
    func next() {
        let n = ComplexTests.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(pageIndex, forKey: "complex")
        self.showPage(index: self.pageIndex)
    }
    
    func back() {
        let n = ComplexTests.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: "complex")
        self.showPage(index: self.pageIndex)
    }
    
    func getName() -> String {
        return "test \(self.pageIndex)"
    }
}