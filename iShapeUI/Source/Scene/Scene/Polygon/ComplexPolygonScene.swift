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

    private var data: [[Point]] = []
    private var aIndex: ActiveIndex?

    override init() {
        super.init()
        self.showPage(index: ComplexTests.pageIndex)
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

        let indices = pShape.delaunay(extraPoints: nil).convexPolygonsIndices
        let shapePoints = iGeom.float(points: pShape.points).toCGPoints()
        
        var svgPath = [[CGPoint]]()
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
            svgPath.append(polygon)
            let shape = ShapeLinePolygon(points: polygon, lineWidth: 0.08, color: .init(gray: 0.5, alpha: 1))
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

            self.addSublayer(ShapeVectorPolygon(points: points, shift: -1.0, tip: 1.0, lineWidth: 0.2, color: Colors.master, indexShift: 2.5, data: nil))
            self.addSublayer(ShapeLinePolygon(points: points, lineWidth: 0.16, color: Colors.darkGray))
            svgPath.append(points)
        }
        
        SVG.svgPrint(pathes: svgPath, lines: [])
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
        self.showPage(index: ComplexTests.nextIndex())
    }
    
    func back() {
        self.showPage(index: ComplexTests.prevIndex())
    }
    
    func getName() -> String {
        return "test \(ComplexTests.pageIndex)"
    }
}



