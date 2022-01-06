//
//  PlainMonotoneSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry

struct PlainMonotoneSceneView: View {

    @EnvironmentObject var inputSystem: InputSystem
    @ObservedObject var state = PlainMonotoneSceneState()
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom

    init(sceneState: SceneState) {
        self.sceneState = sceneState
    }
    
    private struct Triangle {
        let index: Int
        let points: [CGPoint]
    }
    
    var body: some View {
        self.state.inputSystem = self.inputSystem
        let points = state.data
        let shape = PlainShape(points: iGeom.int(points: points))
        
        let indices = shape.triangulate()
        var triangles = [Triangle]()
        triangles.reserveCapacity(indices.count / 3)
        var i = 0
        while i < indices.count {
            let a = points[indices[i]]
            let b = points[indices[i + 1]]
            let c = points[indices[i + 2]]
            let abc = [a, b, c].map({ CGPoint(x: CGFloat($0.x), y: CGFloat($0.y)) })
            triangles.append(Triangle(index: i / 3, points: abc))
            i += 3
        }
        
        let stroke = colorSchema.schema.defaultTriangleStroke

        return ZStack {
            ForEach(triangles, id: \.index) { triangle in // show received results
                TriangleShapeView(
                    sceneState: self.sceneState,
                    points: triangle.points,
                    index: triangle.index,
                    stroke: stroke,
                    lineWidth: 1.2
                )
            }
            PlainShapeView(sceneState: sceneState, shape: shape, stroke: colorSchema.schema.defaultPolygonStroke, iGeom: iGeom)
        }
    }
 
}
