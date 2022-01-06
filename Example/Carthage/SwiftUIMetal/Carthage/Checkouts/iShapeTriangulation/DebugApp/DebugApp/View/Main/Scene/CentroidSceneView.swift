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

    @ObservedObject var state = UniversalSceneState(key: String(describing: CentroidNetSceneView.self), tests: CentroidTestData.data)
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
            let bundle = state.data.bundle
            
            if let centroidNet = try? triangulator.centroidNet(points: bundle.points, hull: bundle.hull, holes: bundle.holes, onlyConvex: true, maxEdge: 4, minArea: 0, extraPoints: bundle.extraPoints) {
                centroids.reserveCapacity(centroidNet.count)
                for path in centroidNet {
                    let points = path.cgPoints
                    centroids.append(Centroid(index: centroids.count, points: points))
                }
            }
        }

        let stroke = colorSchema.schema.defaultPolygonStroke

        return ZStack(alignment: .top) {
            Text("CentroidNet: \(state.pageIndex)")
                .font(.title)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
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
