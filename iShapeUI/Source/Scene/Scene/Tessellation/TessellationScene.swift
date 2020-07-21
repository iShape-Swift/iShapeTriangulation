//
//  TessellationScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 07.05.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class TessellationScene: CoordinateSystemScene {

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
        var pShape = PlainShape(iShape: iShape)

        var isValid: Bool = false
        if case .valid = pShape.validate() {
            isValid = true
        }
        
        var svgPath = [[CGPoint]]()
        
        if isValid {
            pShape.modify(maxEgeSize: iGeom.int(float: 4))
            var delaunay = pShape.delaunay(extraPoints: nil)
            let extraVertex = delaunay.tessellate(maxAngle: 0.5 * Float.pi, minEdge: iGeom.int(float: 4))

            delaunay.build()
            let triangles = delaunay.trianglesIndices
            let shapePoints = iGeom.float(points: pShape.points + extraVertex.map({ $0.point }) ).toCGPoints()
            var triangle = [Int]()
            var k = 0
            for i in triangles {
                triangle.append(i)
                if triangle.count == 3 {
                    let cgPoints = triangle.map({ shapePoints[$0] })
                    let shapeTriangle = ShapeTriangle(points: cgPoints, text: "", color: Colors.gray, lineWidth: 0.08)
                    self.addSublayer(shapeTriangle)
                    svgPath.append(cgPoints)
                    triangle.removeAll()
                    k += 1
                }
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
                self.addSublayer(ShapeLinePolygon(points: points, lineWidth: 0.16, color: Colors.darkGray))
            }
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
            if !isValid {
                self.addSublayer(ShapeLinePolygon(points: points, lineWidth: 0.4, color: Colors.red))
            }
            self.addSublayer(ShapeVertexPolygon(points: points, radius: 1, color: dotColor, indexShift: 2.5, data: data))
            svgPath.append(points)
        }

        SVG.svgPrint(pathes: svgPath)
    }
    
    func showPage(index: Int) {
        self.data = ComplexTests.data[index]
        self.update()
    }
    
}

extension TessellationScene: MouseCompatible {

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

extension TessellationScene: SceneNavigation {
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
