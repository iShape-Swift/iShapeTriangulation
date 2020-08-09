//
//  SceneState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 06.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

final class SceneState: ObservableObject {
    
    private static let defaultZoom: CGFloat = 0.1
    private let maxZoom: CGFloat = 1
    private let minZoom: CGFloat = 0.01
    private let limitZoom: CGFloat = 1.1

    weak var scene: Scene?
    
    var sceneTopLeft: CGPoint {
        let scale = 0.5 * zoom
        return CGPoint(x: viewPoint.x - scale * sceneSize.width, y: viewPoint.y - scale * sceneSize.height)
    }
    
    var sceneBottomRight: CGPoint {
        let scale = 0.5 * zoom
        return CGPoint(x: viewPoint.x + scale * sceneSize.width, y: viewPoint.y + scale * sceneSize.height)
    }
    
    @Published var sceneSize: CGSize = .zero
    @Published var zoom: CGFloat = SceneState.defaultZoom
    @Published var viewPoint: CGPoint = .zero
    
    private var zoomOrigin: CGFloat = 1
    private var viewPointOrigin: CGPoint = .zero
    
    init(inputSystem: InputSystem) {
        inputSystem.onDown = { [weak self] keyCode in
            if keyCode == 124 || keyCode == 49 || keyCode == 36 {
                self?.scene?.onNext()
                return true
            } else if keyCode == 123 {
                self?.scene?.onPrev()
                return true
            } else {
                return false
            }
        }
    }
    
    func modify(scale: CGFloat) {
        let zoom = self.zoomOrigin * scale
        if zoom > maxZoom * limitZoom {
            self.zoom = maxZoom * limitZoom
        } else if zoom < minZoom / limitZoom {
            self.zoom = minZoom / limitZoom
        } else {
            self.zoom = self.zoomOrigin * scale
        }
    }
    
    func apply(scale: CGFloat) {
        var zoom = self.zoomOrigin * scale
        if zoom > self.maxZoom {
            zoom = self.maxZoom
        } else if zoom < self.minZoom {
            zoom = self.minZoom
        }
        self.zoomOrigin = zoom
        if self.zoom != zoom {
            self.zoom = zoom
        }
    }
    
    func move(translation: CGSize) {
        let dx = -translation.width * zoom
        let dy = translation.height * zoom
        self.viewPoint = CGPoint(x: self.viewPointOrigin.x + dx, y: self.viewPointOrigin.y + dy)
    }
    
    func apply(translation: CGSize) {
        let dx = -translation.width * zoom
        let dy = translation.height * zoom
        self.viewPointOrigin = CGPoint(x: self.viewPointOrigin.x + dx, y: self.viewPointOrigin.y + dy)
        self.viewPoint = self.viewPointOrigin
        if self.viewPoint != self.viewPointOrigin {
            self.viewPoint = self.viewPointOrigin
        }
    }

    func reset() {
        self.zoom = SceneState.defaultZoom
        self.zoomOrigin = SceneState.defaultZoom
        self.viewPoint = .zero
        self.viewPointOrigin = .zero
    }

    func screen(world: CGPoint) -> CGPoint {
        let scale = 0.5 * zoom
        let left = viewPoint.x - scale * sceneSize.width
        let bottom = viewPoint.y + scale * sceneSize.height

        let x = (world.x - left) / zoom
        let y = (bottom - world.y) / zoom
        return CGPoint(x: x, y: y)
    }
    
    func screen(world: [CGPoint]) -> [CGPoint] {
        let scale = 0.5 * zoom
        let left = viewPoint.x - scale * sceneSize.width
        let bottom = viewPoint.y + scale * sceneSize.height

        var result = [CGPoint](repeating: .zero, count: world.count)
        world.withUnsafeBufferPointer { buffer in
            for i in 0..<buffer.count {
                let p = buffer[i]
                let x = (p.x - left) / zoom
                let y = (bottom - p.y) / zoom
                result[i] = CGPoint(x: x, y: y)
            }
        }
        return result
    }
    
}
