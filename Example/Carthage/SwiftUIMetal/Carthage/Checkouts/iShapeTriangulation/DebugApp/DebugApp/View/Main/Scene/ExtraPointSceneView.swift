//
//  ExtraPointSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

struct ExtraPointSceneView: View {

    @ObservedObject var state = ComplexSceneState(key: String(describing: ExtraPointSceneView.self), data: ExtraPointsTests.data)
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
        var shape: PlainShape = .empty
        var triangles = [Triangle]()
        var extraPoints = [Point]()

        if !isDisabled {
            var paths = state.paths
            extraPoints = paths.removeLast()
            let extra = iGeom.int(points: extraPoints)
            if self.state.paths.count == 1 {
                shape = PlainShape(iGeom: iGeom, hull: paths[0])
            } else {
                let hull = paths.remove(at: 0)
                shape = PlainShape(iGeom: iGeom, hull: hull, holes: paths)
            }

            if let indices = try? shape.delaunay(extraPoints: extra).trianglesIndices {
                let points = iGeom.float(points: shape.points + extra)

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
            ForEach(extraPoints, id: \.x) { point in
                DotShapeView(
                    sceneState: self.sceneState,
                    point: CGPoint(point),
                    radius: 4,
                    color: self.colorSchema.schema.defaultPolygonStroke
                )
            }
            PlainShapeView(sceneState: sceneState, shape: shape, stroke: colorSchema.schema.defaultPolygonStroke, iGeom: iGeom)
        }
    }

}
