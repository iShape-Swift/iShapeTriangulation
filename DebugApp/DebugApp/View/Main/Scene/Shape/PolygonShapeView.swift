//
//  PolygonShapeView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry

struct PolygonShapeView: View {

    private let points: [CGPoint]
    private let stroke: Color
    private let lineWidth: CGFloat
    private let index: Int
    private let showIndex: Bool
    @ObservedObject private var sceneState: SceneState

    init(sceneState: SceneState, points: [CGPoint], index: Int, stroke: Color = .gray, lineWidth: CGFloat = 1, showIndex: Bool = true) {
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.sceneState = sceneState
        self.index = index
        self.points = points
        self.showIndex = showIndex
    }

    var body: some View {
        let screenPoints = sceneState.screen(world: points)
        return ZStack {
            Path { path in
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: self.lineWidth)).foregroundColor(self.stroke)
            Text("\(index)").foregroundColor(self.stroke).position(screenPoints.center).isHidden(!showIndex)
        }
    }
}

private extension Array where Element == CGPoint {
    
    var center: CGPoint {
        var x: CGFloat = 0
        var y: CGFloat = 0
        for p in self {
            x += p.x
            y += p.y
        }
        let n = CGFloat(self.count)
        return CGPoint(x: x / n, y: y / n)
    }
    
}
