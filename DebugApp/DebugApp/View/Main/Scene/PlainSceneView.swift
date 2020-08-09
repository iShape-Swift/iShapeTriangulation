//
//  PlainSceneView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry

struct PlainSceneView: View {

    @ObservedObject var state = PlainSceneState()
    private let sceneState: SceneState
    private let iGeom = IntGeom.defGeom

    init(sceneState: SceneState) {
        self.sceneState = sceneState
    }
    
    var body: some View {
        
        let points = state.data
        let shape = PlainShape(points: iGeom.int(points: points))
        
        return PlainShapeView(sceneState: sceneState, shape: shape, iGeom: iGeom)
    }
}
