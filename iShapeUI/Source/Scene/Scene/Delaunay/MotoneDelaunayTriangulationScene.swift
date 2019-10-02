//
//  MotoneDelaunayTriangulationScene.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 11/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation

import Cocoa
import iGeometry
@testable import iShapeTriangulation

final class MotoneDelaunayTriangulationScene: CoordinateSystemScene {
    
    private var pageIndex: Int = UserDefaults.standard.integer(forKey: "monotone")
    private var data: [Point] = []
    private var index: Int?

    private var circles = [Point: Set<CircleBundle>]()
    
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
        
        var info = [String]()
        info.reserveCapacity(data.count)
        for i in 0..<data.count {
            info.append(String(i))
        }
        
        let iPoints = iGeom.int(points: data)
        
        let iShape = IntShape(hull: iPoints, holes: [])
        let pShape = PlainShape(iShape: iShape)
        
        let color: CGColor
        let isValid = iPoints.isMonotone
        if isValid {
            color = Colors.master
            
            let triangles = pShape.triangulateDelaunay()
            
            var triangle = [Int]()
            var k = 0
            circles.removeAll()
            for i in triangles {
                triangle.append(i)
                if triangle.count == 3 {
                    
                    let abc = triangle.map({ self.data[$0] })
                    let circle = Delaunay.circumscribedСircleCenter(a: abc[0], b: abc[1], c: abc[2])
                    let cirShape = ShapeCircle(
                        position: circle.center.toCGPoint,
                        radius: CGFloat(circle.radius),
                        color: .clear,
                        depth: 0.2
                    )
                    
                    for p in abc {
                        let bundle = CircleBundle(circle: circle, shape: cirShape)
                        if var set = self.circles[p] {
                            if !set.contains(bundle) {
                                set.insert(bundle)
                                self.circles[p] = set
                            }
                        } else {
                            self.circles[p] = Set([bundle])
                        }
                    }
                    
                    let shapeTriangle = ShapeTriangle(points: abc.toCGPoints(), text: String(k), color: Colors.lightGray)
                    
                    
                    self.addSublayer(shapeTriangle)
                    
                    triangle.removeAll()
                    k += 1
                }
            }
            
            for sets in self.circles.values {
                for bundle in sets {
                    self.addSublayer(bundle.shape)
                }
            }
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


extension MotoneDelaunayTriangulationScene: MouseCompatible {
    
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
        let length: Float = 2.0
        for sets in self.circles.values {
            for bundle in sets {
                bundle.shape.strokeColor = .clear
            }
        }
        
        guard let index = findNearest(point: point.point, sqrR: length * length) else {
            return
        }
        
        let dot = data[index]
        
        guard let set = self.circles[dot] else {
            return
        }
        
        let mousePoint = point.point

        let dx = mousePoint.x - dot.x
        let dy = mousePoint.y - dot.y

        let alpha = 1 - sqrt(dx * dx + dy * dy) / length
        
        for bundle in set {
            bundle.shape.strokeColor = NSColor(white: 0.2, alpha: CGFloat(alpha)).cgColor
        }
        
    }
    
}

extension MotoneDelaunayTriangulationScene: SceneNavigation {
    func next() {
        let n = ComplexTests.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(pageIndex, forKey: "monotone")
        self.showPage(index: self.pageIndex)
    }
    
    func back() {
        let n = ComplexTests.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: "monotone")
        self.showPage(index: self.pageIndex)
    }
    
    func getName() -> String {
        return "test \(self.pageIndex)"
    }
}

extension Point: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}


private struct CircleBundle: Hashable {

    let circle: Delaunay.Circle
    let shape: ShapeCircle
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(circle.radius)
        hasher.combine(circle.center)
    }
    
    static func == (lhs: CircleBundle, rhs: CircleBundle) -> Bool {
        return lhs.circle.radius == rhs.circle.radius && lhs.circle.center == rhs.circle.center
    }
}

