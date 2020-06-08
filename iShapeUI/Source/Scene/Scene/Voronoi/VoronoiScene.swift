//
//  VoronoiScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 20.05.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class VoronoiScene: CoordinateSystemScene {

    private var data: [[Point]] = []
    private var aIndex: ActiveIndex?
    private let iGeom = IntGeom()

    override init() {
        super.init()
        self.showPage(index: TessellationTests.pageIndex)
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

        let shape = self.getShape()
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)

        let extra = self.getExtra()
        
        let delaunay = pShape.delaunay(extraPoints: extra)
        
        let circles = delaunay.getCircles(intGeom: iGeom)
        let iCircles = delaunay.getInscribedCircles(intGeom: iGeom)
        let triangles = delaunay.trianglesIndices
        let shapePoints = iGeom.float(points: pShape.points + extra).toCGPoints()

        var svgPath = [[CGPoint]]()
        
        var triangle = [Int]()
        var k = 0
        for i in triangles {
            triangle.append(i)
            if triangle.count == 3 {
                let cgPoints = triangle.map({ shapePoints[$0] })
                let shapeTriangle = ShapeTriangle(points: cgPoints, text: ""/*String(k)*/, color: Colors.gray, lineWidth: 0.08)
                self.addSublayer(shapeTriangle)
                svgPath.append(cgPoints)
                triangle.removeAll()
                k += 1
            }
        }

        let pathes = pShape.pathes
        let dotColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)

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
            svgPath.append(points)
            self.addSublayer(ShapeLinePolygon(points: points, lineWidth: 0.16, color: Colors.darkGray))
        }
        
        
        let cgExtra = iGeom.float(points: extra).toCGPoints()
        
        for vertex in cgExtra {
            self.addSublayer(ShapeDot(position: vertex, radius: 1, color: dotColor))
        }
        
        for circle in circles {
            self.addSublayer(ShapeDot(position: circle.toCGPoint, radius: 1, color: Colors.orange))
        }
        
        for circle in iCircles {
            self.addSublayer(ShapeDot(position: circle.toCGPoint, radius: 1, color: Colors.darkGreen))
        }
        
        SVG.svgPrint(pathes: svgPath)
    }
    
    func showPage(index: Int) {
        self.data = TessellationTests.data[index]
        self.update()
    }
    
}

extension VoronoiScene: MouseCompatible {

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
        if !holes.isEmpty {
            holes.removeLast()
        }
        return Shape(hull: hull, holes: holes)
    }
    
    private func getExtra() -> [IntPoint] {
        if let last = data.last {
            return iGeom.int(points: last)
        } else {
            fatalError("can not be null")
        }
    }
    
}

extension VoronoiScene: SceneNavigation {
    func next() {
        self.showPage(index: TessellationTests.nextIndex())
    }
    
    func back() {
        self.showPage(index: TessellationTests.prevIndex())
    }
    
    func getName() -> String {
        return "test \(TessellationTests.pageIndex)"
    }
}
