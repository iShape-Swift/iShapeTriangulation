//
//  PolygonSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

struct PolygonSceneView: View {

    @ObservedObject var state = ComplexSceneState(key: String(describing: PolygonSceneView.self), data: ComplexTests.data)
//    @ObservedObject var state = ComplexSceneState(key: String(describing: PolygonSceneView.self), data: ExtraPointsTests.data)
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom
    private let isDisabled: Bool

    init(sceneState: SceneState, isDisabled: Bool) {
        self.sceneState = sceneState
        self.isDisabled = isDisabled
    }
    
    private struct Polygon {
        let index: Int
        let points: [CGPoint]
    }
    
    var body: some View {
        var shape: PlainShape = .empty
        var polygons = [Polygon]()
        
        if !self.isDisabled {
            var paths = state.paths
            let extra: [IntPoint]? = nil // iGeom.int(points: paths.removeLast())
            if self.state.paths.count == 1 {
                shape = PlainShape(iGeom: iGeom, hull: paths[0])
            } else {
                let hull = paths.remove(at: 0)
                shape = PlainShape(iGeom: iGeom, hull: hull, holes: paths)
            }

            if let indices = try? shape.delaunay(extraPoints: extra).convexPolygonsIndices {
                let points = iGeom.float(points: shape.points/* + extra*/)
                
                var i = 0
                while i < indices.count {
                    let n = indices[i]
                    i += 1
                    var path = [CGPoint](repeating: .zero, count: n)
                    for j in 0..<n {
                        let index = indices[j + i]
                        path[j] = CGPoint(points[index])
                    }
                    polygons.append(Polygon(index: polygons.count, points: path))
                    i += n
                }
            }
        }

        let stroke = colorSchema.schema.defaultTriangleStroke

        return ZStack {
            ForEach(polygons, id: \.index) { triangle in
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
