//
//  PlainShapeView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry

struct PlainShapeView: View {

    private let iGeom: IntGeom
    private let paths: [[CGPoint]]
    private let stroke: Color
    private let lineWidth: CGFloat
    @ObservedObject private var sceneState: SceneState

    init(sceneState: SceneState, shape: PlainShape, stroke: Color = .gray, lineWidth: CGFloat = 2, iGeom: IntGeom = .defGeom) {
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.iGeom = iGeom
        self.sceneState = sceneState
        let points = iGeom.float(points: shape.points).map({ CGPoint($0) })
        var paths = [[CGPoint]]()
        paths.reserveCapacity(shape.layouts.count)
        if !shape.points.isEmpty {
            for layout in shape.layouts {
                paths.append(Array(points[layout.begin...layout.end]))
            }
        }
        self.paths = paths
    }

    var body: some View {
        return Path { path in
            for points in paths {
                let screenPoints = sceneState.screen(world: points)
                path.addLines(screenPoints)
                path.closeSubpath()
            }
        }.strokedPath(.init(lineWidth: self.lineWidth)).foregroundColor(self.stroke)
    }
}
