//
//  TessellationSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

struct TessellationSceneView: View {

    @ObservedObject var state = ComplexSceneState(key: String(describing: TessellationSceneView.self), data: ExtraPointsTests.data)
//    @ObservedObject var state = ComplexSceneState(key: String(describing: TessellationSceneView.self), data: ComplexTests.data)
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let triangulator = Triangulator(iGeom: IntGeom.defGeom)
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
        var extraPoints = [Point]()
        var triangles = [Triangle]()
        var paths = [[Point]]()
        
        if !isDisabled {
            paths = state.paths

            extraPoints = paths.removeLast()
            let points = paths.flatMap({ $0 })
            let path = paths[0]
            
            let hull = points[0..<path.count]
            
            var holes = [ArraySlice<Point>]()
            var n = hull.count
            if paths.count > 1 {
                for i in 1..<paths.count {
                    let hole = paths[i]
                    holes.append(points[n..<n + hole.count])
                    n += hole.count
                }
            }

            let result = triangulator.tessellate(points: points, hull: hull, holes: holes.isEmpty ? nil : holes, maxEdge: 4, extraPoints: extraPoints)

            triangles.reserveCapacity(result.indices.count / 3)
            var i = 0
            while i < result.indices.count {
                let a = CGPoint(result.points[result.indices[i]])
                let b = CGPoint(result.points[result.indices[i + 1]])
                let c = CGPoint(result.points[result.indices[i + 2]])
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
                    lineWidth: 1.2,
                    showIndex: false
                )
            }
            ForEach(extraPoints, id: \.self) { point in
                DotShapeView(
                    sceneState: self.sceneState,
                    point: CGPoint(point),
                    radius: 4,
                    color: self.colorSchema.schema.defaultPolygonStroke
                )
            }
            PathShapeView(sceneState: sceneState, paths: paths, stroke: colorSchema.schema.defaultPolygonStroke)
        }
    }
}
