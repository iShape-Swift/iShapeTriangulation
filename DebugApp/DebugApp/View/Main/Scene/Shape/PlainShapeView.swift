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
    @ObservedObject private var sceneState: SceneState
    @State var strokeColor: Color = .gray

    init(sceneState: SceneState, shape: PlainShape, iGeom: IntGeom = .defGeom) {
        self.iGeom = iGeom
        self.sceneState = sceneState
        let points = iGeom.float(points: shape.points).map({ CGPoint(x: CGFloat($0.x), y: CGFloat($0.y)) })
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
        }.strokedPath(.init(lineWidth: 2)).foregroundColor(self.strokeColor)
    }
}
