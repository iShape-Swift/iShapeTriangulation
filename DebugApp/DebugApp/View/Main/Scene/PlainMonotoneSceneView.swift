//
//  PlainMonotoneSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

struct PlainMonotoneSceneView: View {

    @ObservedObject var state = BasicSceneState(key: String(describing: PlainMonotoneSceneView.self), data: MonotoneTests.data)
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
        var shape = PlainShape.empty
        var triangles = [Triangle]()
        
        if !isDisabled {
            let points = state.points
            shape = PlainShape(points: iGeom.int(points: points))
            
            let indices = shape.triangulate()
            
            triangles.reserveCapacity(indices.count / 3)
            var i = 0
            while i < indices.count {
                let a = CGPoint(points[indices[i]])
                let b = CGPoint(points[indices[i + 1]])
                let c = CGPoint(points[indices[i + 2]])
                triangles.append(Triangle(index: i / 3, points: [a, b, c]))
                i += 3
            }
        }
        
        let stroke = colorSchema.schema.defaultTriangleStroke

        return ZStack {
            ForEach(triangles, id: \.index) { triangle in
                PolygonShapeView(
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
