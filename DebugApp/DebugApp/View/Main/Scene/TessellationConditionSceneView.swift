//
//  TessellationConditionSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 17.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
@testable import iShapeTriangulation

struct TessellationConditionSceneView: View {

    private struct Vertex {
        let point: CGPoint
        let name: String
    }
    
    @ObservedObject var state = BasicSceneState(
        key: String(describing: TessellationConditionSceneView.self),
        data: [
            [
                Point(x:-25, y:  5), Point(x: 10, y: 15), Point(x:20, y: -15), Point(x: 25, y: 5), Point(x: 0, y: 0)
            ]
        ]
    )
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom
    private let isDisabled: Bool

    init(sceneState: SceneState, isDisabled: Bool) {
        self.sceneState = sceneState
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        let points = state.points
        let a = points[0]
        let b = points[1]
        let c = points[2]
        let p = points[3]
        let s = points[4]

        let m = Self.middle2(a: a, b: b, c: p, d: c)
        
        let exPoint = TessellationConditionSceneView.extraPoint(a: p, b: b, c: c)
        
        var circles = [iGeometry.Circle]()
        
        let abc = iGeometry.Triangle.circumscribedСircle(a: a, b: b, c: c)

        circles.append(iGeometry.Triangle.circumscribedСircle(a: a, b: b, c: s))
        circles.append(iGeometry.Triangle.circumscribedСircle(a: a, b: c, c: s))
        circles.append(iGeometry.Triangle.circumscribedСircle(a: s, b: b, c: p))
        circles.append(iGeometry.Triangle.circumscribedСircle(a: s, b: c, c: p))
        
        let bpc = iGeometry.Triangle.circumscribedСircle(a: b, b: p, c: c)
        
        
        let vertices = [
            Vertex(point: CGPoint(a), name: "a"),
            Vertex(point: CGPoint(b), name: "b"),
            Vertex(point: CGPoint(c), name: "c"),
            Vertex(point: CGPoint(p), name: "p"),
            Vertex(point: CGPoint(s), name: "s")
        ]

        return ZStack {
//            Circle()
//                .stroke(Color.yellow, lineWidth: 4)
//                .frame(
//                    width: self.sceneState.screen(world: CGFloat(2 * abc.radius)),
//                    height: self.sceneState.screen(world: CGFloat(2 * abc.radius)),
//                    alignment: .center
//            )
//                .position(self.sceneState.screen(world: CGPoint(abc.center)))
//            ForEach(circles, id: \.radius) { circle in
//                Circle()
//                    .stroke(Color(white: 0.8), lineWidth: 4)
//                    .frame(
//                        width: self.sceneState.screen(world: CGFloat(2 * circle.radius)),
//                        height: self.sceneState.screen(world: CGFloat(2 * circle.radius)),
//                        alignment: .center
//                )
//                    .position(self.sceneState.screen(world: CGPoint(circle.center)))
//            }
//            Circle()
//                .fill().foregroundColor(.yellow)
//                .frame(
//                    width: self.sceneState.screen(world: CGFloat(2)),
//                    height: self.sceneState.screen(world: CGFloat(2)),
//                    alignment: .center
//            )
//                .position(self.sceneState.screen(world: CGPoint(bpc.center)))
//            Circle()
//                .fill().foregroundColor(.yellow)
//                .frame(
//                    width: self.sceneState.screen(world: CGFloat(2)),
//                    height: self.sceneState.screen(world: CGFloat(2)),
//                    alignment: .center
//            )
//                .position(self.sceneState.screen(world: CGPoint(exPoint)))
            Circle()
                .fill().foregroundColor(.blue)
                .frame(
                    width: self.sceneState.screen(world: CGFloat(2)),
                    height: self.sceneState.screen(world: CGFloat(2)),
                    alignment: .center
            )
                .position(self.sceneState.screen(world: CGPoint(m)))
            Path { path in
                let screenPoints = sceneState.screen(world: [a, b, p, c].map({ CGPoint($0) }))
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 4, lineJoin: .round)).foregroundColor(Color(white: 0.8))
//            Path { path in
//                let screenPoints = sceneState.screen(world: [a, b, s].map({ CGPoint($0) }))
//                path.addLines(screenPoints)
//                path.closeSubpath()
//            }.strokedPath(.init(lineWidth: 2, lineJoin: .round)).foregroundColor(Color(white: 0.3))
//            Path { path in
//                let screenPoints = sceneState.screen(world: [a, c, s].map({ CGPoint($0) }))
//                path.addLines(screenPoints)
//                path.closeSubpath()
//            }.strokedPath(.init(lineWidth: 2, lineJoin: .round)).foregroundColor(Color(white: 0.3))
//            Path { path in
//                let screenPoints = sceneState.screen(world: [s, b, p].map({ CGPoint($0) }))
//                path.addLines(screenPoints)
//                path.closeSubpath()
//            }.strokedPath(.init(lineWidth: 2, lineJoin: .round)).foregroundColor(Color(white: 0.3))
//            Path { path in
//                let screenPoints = sceneState.screen(world: [s, c, p].map({ CGPoint($0) }))
//                path.addLines(screenPoints)
//                path.closeSubpath()
//            }.strokedPath(.init(lineWidth: 2, lineJoin: .round)).foregroundColor(Color(white: 0.3))
            ForEach(vertices, id: \.name) { vertex in
                Text(vertex.name).bold().position(self.sceneState.screen(world: vertex.point)).foregroundColor(.red)
            }
        }.allowsHitTesting(false)
    }
    
    static private func extraPoint(a: Point, b: Point, c: Point) -> Point {
        let ab = a - b
        let ca = c - a
        if ab.magnitude > ca.magnitude {
            let r = a + ca.ccwRotate60
            return r
        } else {
            let r = a - ab.cwRotate60
            return r
        }
    }

    private static func middle2(a: Point, b: Point, c: Point, d: Point) -> Point {
        let s = Self.area(a: a, b: b, c: c, d: d)

        var x: Float = 0
        var y: Float = 0
        var q: Float = 0

        q = a.x * d.y - d.x * a.y
        x += (a.x + d.x) * q
        y += (a.y + d.y) * q

        q = b.x * a.y - a.x * b.y
        x += (b.x + a.x) * q
        y += (b.y + a.y) * q
        
        q = c.x * b.y - d.x * c.y
        x += (c.x + b.x) * q
        y += (c.y + b.y) * q
        
        q = d.x * c.y - c.x * d.y
        x += (d.x + c.x) * q
        y += (d.y + c.y) * q
        let k = 1 / (+3 * s)

        return Point(x: k * x, y: k * y)
    }
    
    private static func area(a: Point, b: Point, c: Point, d: Point) -> Float {
        (b.x - a.x) * (b.y + a.y) + (c.x - b.x) * (c.y + b.y) + (d.x - c.x) * (d.y + c.y) + (a.x - d.x) * (a.y + d.y)
    }
    
    private static func middle(a: Point, b: Point, c: Point, d: Point) -> Point {
        let points = [a, b, c, d]
        var x: Float = 0
        var y: Float = 0
        var p2 = d
        for i in 0...3 {
            let p1 = points[i]
            let d = p1.x * p2.y - p2.x * p1.y
            x += (p1.x + p2.x) * d
            y += (p1.y + p2.y) * d

            p2 = p1
        }
        
        let s = Self.area(a: a, b: b, c: c, d: d)

        let k = 1 / (3 * s)
        
        return Point(x: k * x, y: k * y)
    }
    
}

private extension Point {
    
    private static let sin60: Float = 0.5 * Float(3).squareRoot()
    private static let cos60: Float = 0.5
    
    var magnitude: Float {
        return x * x + y * y
    }
    
    var cwRotate60: Point {
        let x = self.x * Point.cos60 - self.y * Point.sin60
        let y = self.x * Point.sin60 + self.y * Point.cos60
        return Point(x: x, y: y)
    }
    
    var ccwRotate60: Point {
        let x = self.x * Point.cos60 + self.y * Point.sin60
        let y = -self.x * Point.sin60 + self.y * Point.cos60
        return Point(x: x, y: y)
    }
    
}

private func +(left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

private func -(left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x, y: left.y - right.y)
}

private func *(left: Float, right: Point) -> Point {
    return Point(x: left * right.x, y: left * right.y)
}

private func /(left: Point, right: Float) -> Point {
    return Point(x: left.x / right, y: left.y / right)
}
