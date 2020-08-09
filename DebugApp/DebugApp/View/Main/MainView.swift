//
//  MainView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 03.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @ObservedObject private var contentState: ContentState
    private let sceneState: SceneState

    init(state: ContentState, inputSystem: InputSystem) {
        self.contentState = state
        self.sceneState = SceneState(inputSystem: inputSystem)
    }

    var body: some View {
        return GeometryReader { geometry in
            ZStack {
                СoordinateView(state: self.sceneState).background(Color.white)
                self.content(size: geometry.size)
            }.gesture(
                MagnificationGesture()
                    .onChanged { scale in
                        self.sceneState.modify(scale: scale)
                }
                .onEnded { scale in
                    self.sceneState.apply(scale: scale)
                })
            .gesture(
                DragGesture()
                    .onChanged { data in
                        self.sceneState.move(translation: data.translation)
                }
                .onEnded { data in
                    self.sceneState.apply(translation: data.translation)
                }
            )
        }
    }

    func content(size: CGSize) -> some View {
        defer {
            self.sceneState.reset()
        }
        self.sceneState.sceneSize = size
        switch self.contentState.current {
        case .plain:
            let scene = PlainSceneView(sceneState: self.sceneState)
            self.sceneState.scene = scene.state
            return scene
        case .monotone:
            let scene = PlainSceneView(sceneState: self.sceneState)
            self.sceneState.scene = scene.state
            return scene
        }
    }
    
}
