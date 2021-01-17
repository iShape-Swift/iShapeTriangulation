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

    @ObservedObject var state = ComplexSceneState(key: String(describing: CentroidNetSceneView.self), data: ComplexTests.data)
//    @ObservedObject var state = ComplexSceneState(key: String(describing: CentroidNetSceneView.self), data: ExtraPointsTests.data)
    @EnvironmentObject var colorSchema: ColorSchema

    private let triangulator = Triangulator(iGeom: IntGeom.defGeom)
    private let sceneState: SceneState
    private let isDisabled: Bool

    init(sceneState: SceneState, isDisabled: Bool) {
        self.sceneState = sceneState
        self.isDisabled = isDisabled
    }
    
    private struct Centroid {
        let index: Int
        let points: [CGPoint]
    }
    
    var body: some View {
        var centroids = [Centroid]()
        
        if !isDisabled {
            let paths = state.paths

            let extraPoints: [Point]? = nil  //= paths.removeLast()
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
            
            let centroidNet = triangulator.centroidNet(points: points, hull: hull, holes: holes, onlyConvex: false, maxEdge: 0, minArea: 0, extraPoints: extraPoints)

            centroids.reserveCapacity(centroidNet.count)
            for path in centroidNet {
                let points = path.cgPoints
                centroids.append(Centroid(index: centroids.count, points: points))
            }
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
