//
//  DotShapeView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct DotShapeView: View {

    private let color: Color
    private let point: CGPoint
    private let radius: CGFloat
    @ObservedObject private var sceneState: SceneState

    init(sceneState: SceneState, point: CGPoint, radius: CGFloat, color: Color = .gray) {
        self.sceneState = sceneState
        self.color = color
        self.radius = radius
        self.point = point
    }

    var body: some View {
        let screenPoint = sceneState.screen(world: point)
        return Circle()
            .fill(self.color)
            .frame(width: 2 * radius, height: 2 * radius)
            .position(x: screenPoint.x, y: screenPoint.y)
    }
}
