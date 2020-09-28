//
//  CentroidSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

struct CentroidNetSceneView: View {

    @ObservedObject var state = ComplexSceneState(key: String(describing: CentroidNetSceneView.self), data: ExtraPointsTests.data)
    @EnvironmentObject var colorSchema: ColorSchema
    
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom

    init(sceneState: SceneState) {
        self.sceneState = sceneState
    }
    
    private struct Centroid {
        let index: Int
        let points: [CGPoint]
    }
    
    var body: some View {
        var shape: PlainShape
        var paths = state.paths
        let extra = iGeom.int(points: paths.removeLast())
        if self.state.paths.count == 1 {
            shape = PlainShape(iGeom: iGeom, hull: paths[0])
        } else {
            let hull = paths.remove(at: 0)
            shape = PlainShape(iGeom: iGeom, hull: hull, holes: paths)
        }
        
        let minEdge = iGeom.int(float: 2)
        let maxEdge = iGeom.int(float: 3)
        
        let centroidNet = shape.makeCentroidNet(extraPoints: extra, onlyConvex: false, minEdge: minEdge, maxEdge: maxEdge)

        
        var centroids = [Centroid]()
        centroids.reserveCapacity(centroidNet.count)
        for path in centroidNet {
            let points = iGeom.float(points: path).map({ CGPoint($0) })
            centroids.append(Centroid(index: centroids.count, points: points))
        }

        let stroke = colorSchema.schema.defaultPolygonStroke

        return ZStack {
            ForEach(centroids, id: \.index) { triangle in
                PolygonShapeView(
                    sceneState: self.sceneState,
                    points: triangle.points,
                    index: triangle.index,
                    stroke: stroke,
                    lineWidth: 2
                )
            }
        }
    }

}
