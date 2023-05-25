//
//  TetragonIntersectionSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 25.05.2023.
//  Copyright © 2023 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
@testable import iShapeTriangulation

struct TetragonIntersectionSceneView: View {

    private struct Vertex {
        let point: CGPoint
        let name: String
    }
    
    @ObservedObject var state = BasicSceneState(
        key: String(describing: TetragonIntersectionSceneView.self),
        data: [
            [
//                Point(x: -10, y: -10),
//                Point(x: -10, y:  10),
//                Point(x:  10, y:  10),
//                Point(x:  10, y: -10),
//                Point(x:   0, y:   0)
                
                Point(x:   1, y:   0),
                Point(x:   5, y:  -5),
                Point(x:   5, y: -10),
                Point(x: -10, y: -10),
                Point(x:   3, y:  -5)
            ]
        ]
    )
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom
    private let isDisabled: Bool
    
    @State
    private var isContain: Bool = false

    init(sceneState: SceneState, isDisabled: Bool) {
        self.sceneState = sceneState
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        let points = state.points
        let a = points[0]
        let b = points[1]
        let c = points[2]
        let d = points[3]
        let p = points[4]

        let ia = iGeom.int(point: a)
        let ib = iGeom.int(point: b)
        let ic = iGeom.int(point: c)
        let id = iGeom.int(point: d)
        let ip = iGeom.int(point: p)
        
        
        DispatchQueue.main.async {
            let value = Tetragon.isContain(a: ia, b: ib, c: ic, d: id, p: ip)
            if value != self.isContain {
                self.isContain = value
            }
        }
        
        
        let vertices = [
            Vertex(point: CGPoint(a), name: "a"),
            Vertex(point: CGPoint(b), name: "b"),
            Vertex(point: CGPoint(c), name: "c"),
            Vertex(point: CGPoint(d), name: "d"),
            Vertex(point: CGPoint(p), name: "p")
        ]

        return ZStack {
            Circle()
                .fill().foregroundColor(isContain ? .red : .blue)
                .frame(
                    width: self.sceneState.screen(world: CGFloat(2)),
                    height: self.sceneState.screen(world: CGFloat(2)),
                    alignment: .center
            )
                .position(self.sceneState.screen(world: CGPoint(p)))
            Path { path in
                let screenPoints = sceneState.screen(world: [a, b, c, d].map({ CGPoint($0) }))
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 4, lineJoin: .round)).foregroundColor(Color(white: 0.8))
            ForEach(vertices, id: \.name) { vertex in
                Text(vertex.name).bold().position(self.sceneState.screen(world: vertex.point)).foregroundColor(.red)
            }
        }.allowsHitTesting(false)
    }
    
}

private func +(left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

private func -(left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x, y: left.y - right.y)
}
