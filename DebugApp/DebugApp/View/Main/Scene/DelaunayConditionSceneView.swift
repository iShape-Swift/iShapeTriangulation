//
//  DelaunayConditionSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
@testable import iShapeTriangulation

struct DelaunayConditionSceneView: View {

    private struct Vertex {
        let point: CGPoint
        let name: String
    }
    
    @ObservedObject var state = BasicSceneState(
        key: String(describing: DelaunayConditionSceneView.self),
        data: [
            [
                Point(x:-15, y:  0), Point(x:-20, y: -5), Point(x:-25, y:  0), Point(x:-20, y: 10)
            ],
            [
                Point(x: -5, y: 30), Point(x:-10, y: 20), Point(x: -5, y: 10), Point(x:  0, y: 20)
            ],
            [
                Point(x:  5, y:  5), Point(x:  5, y:-10), Point(x: 10, y:-20), Point(x: 10, y: -5)
            ],
            [
                Point(x: -5, y:-20), Point(x:-15, y:-25), Point(x:-20, y:-10), Point(x: -5, y: -15)
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
    
    private struct Triangle {
        let index: Int
        let points: [CGPoint]
    }
    
    var body: some View {
        let points = state.points
        let c = points[0]
        let a = points[1]
        let b = points[2]
        let p = points[3]
        
        
        let circle = iGeometry.Triangle.circumscribedСircle(a: a, b: b, c: c)
        
        let ai = iGeom.int(point: a)
        let bi = iGeom.int(point: b)
        let ci = iGeom.int(point: c)
        let pi = iGeom.int(point: p)
        
        let success = Delaunay.isDelaunay(p0: pi, p1: ci, p2: ai, p3: bi)
        let color: Color = success ? .green : .red
        
        let vertices = [
            Vertex(point: CGPoint(a), name: "a"),
            Vertex(point: CGPoint(b), name: "b"),
            Vertex(point: CGPoint(c), name: "c"),
            Vertex(point: CGPoint(p), name: "p")
        ]

        let diameter = CGFloat(2 * circle.radius)
        
        return ZStack {
            Circle()
                .stroke(Color(white: 0.8), lineWidth: 4)
                .frame(
                    width: self.sceneState.screen(world: diameter),
                    height: self.sceneState.screen(world: diameter),
                    alignment: .center
            )
                .position(self.sceneState.screen(world: CGPoint(circle.center)))
            Path { path in
                let screenPoints = sceneState.screen(world: points.map({ CGPoint($0) }))
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 4, lineJoin: .round)).foregroundColor(color)
            ForEach(vertices, id: \.name) { vertex in
                Text(vertex.name).position(self.sceneState.screen(world: vertex.point)).foregroundColor(.black)
            }
        }
    }
}
