//
//  MainView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 03.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var inputSystem: InputSystem
    @ObservedObject private var contentState: ContentState
    private let sceneState: SceneState

    init(state: ContentState) {
        self.contentState = state
        self.sceneState = SceneState()
    }

    var body: some View {
        
        return GeometryReader { geometry in
            ZStack {
                СoordinateView(state: self.sceneState).background(Color.white)
                self.content(size: geometry.size).allowsHitTesting(false)
            }.gesture(MagnificationGesture()
                .onChanged { scale in
                    self.sceneState.modify(scale: scale)
                }
                .onEnded { scale in
                    self.sceneState.apply(scale: scale)
                })
            .gesture(DragGesture()
                .onChanged { data in
                    self.sceneState.move(start: data.startLocation, current: data.location)
                }
                .onEnded { data in
                    self.sceneState.apply(start: data.startLocation, current: data.location)
                }
            )
        }
    }

    func content(size: CGSize) -> some View {
        self.sceneState.sceneSize = size
        
        let plainMonotoneScene = PlainMonotoneSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .plainMonotone)
        let delaunayMonotoneScene = DelaunayMonotoneSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .delaunayMonotone)
        let plainComplexScene = PlainComplexSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .plainComplex)
        let delaunayComplexScene = DelaunayComplexSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .delaunayComplex)
        let polygonScene = PolygonSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .polygon)
        let extraPointScene = ExtraPointSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .extraPoint)
        let centroidNetScene = CentroidNetSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .centroidNet)
        let tessellationScene = TessellationSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .tessellation)
        let delaunayConditionScene = DelaunayConditionSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .delaunayCondition)
        let tessellationConditionScene = TessellationConditionSceneView(sceneState: self.sceneState, isDisabled: self.contentState.current != .tessellationCondition)
        
        let scene: Scene
        
        switch self.contentState.current {
            case .plainMonotone:
                scene = plainMonotoneScene.state
            case .delaunayMonotone:
                scene = delaunayMonotoneScene.state
            case .plainComplex:
                scene = plainComplexScene.state
            case .delaunayComplex:
                scene = delaunayComplexScene.state
            case .polygon:
                scene = polygonScene.state
            case .extraPoint:
                scene = extraPointScene.state
            case .centroidNet:
                scene = centroidNetScene.state
            case .tessellation:
                scene = tessellationScene.state
            case .delaunayCondition:
                scene = delaunayConditionScene.state
            case .tessellationCondition:
                scene = tessellationConditionScene.state
        }

        self.inputSystem.subscribe(scene)
        self.sceneState.scene = scene
        self.sceneState.reset()
        
        return ZStack {
            plainMonotoneScene.isHidden(self.contentState.current != .plainMonotone)
            delaunayMonotoneScene.isHidden(self.contentState.current != .delaunayMonotone)
            plainComplexScene.isHidden(self.contentState.current != .plainComplex)
            delaunayComplexScene.isHidden(self.contentState.current != .delaunayComplex)
            polygonScene.isHidden(self.contentState.current != .polygon)
            extraPointScene.isHidden(self.contentState.current != .extraPoint)
            centroidNetScene.isHidden(self.contentState.current != .centroidNet)
            tessellationScene.isHidden(self.contentState.current != .tessellation)
            delaunayConditionScene.isHidden(self.contentState.current != .delaunayCondition)
            tessellationConditionScene.isHidden(self.contentState.current != .tessellationCondition)
        }
    }
    
}
