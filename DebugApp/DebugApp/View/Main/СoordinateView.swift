//
//  СoordinateView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 06.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct СoordinateView: View {

    private enum Const {
        static let step: CGFloat = 5 // 5px for 1 dimension
    }
    
    @ObservedObject var state: SceneState
    
    init(state: SceneState) {
        self.state = state
    }

    var body: some View {
        let lines = self.lines()
        let anchors = self.anchors()
        let zStack = ZStack {
            Path { path in
                for line in lines {
                    path.move(to: line.a)
                    path.addLine(to: line.b)
                }
            }
            .strokedPath(.init(lineWidth: 0.5)).foregroundColor(.gray)
            Path { path in
                for points in anchors {
                    path.addLines(points)
                }
            }.strokedPath(.init(lineWidth: 1)).foregroundColor(.red).opacity(0.7)
        }
        
        return zStack
    }

    private struct Line {
        let a: CGPoint
        let b: CGPoint
    }

    private func lines() -> [Line] {
        var result = [Line]()

        let worldStep = Const.step
        
        let worldTopLeft = self.state.sceneTopLeft
        let worldBottomRight = self.state.sceneBottomRight

        var worldX = round(worldTopLeft.x / worldStep) * worldStep
        if worldX < worldTopLeft.x {
           worldX += worldStep
        }
        
        let sceneSize = self.state.sceneSize
        
        while worldX < worldBottomRight.x {
            let screen = self.state.screen(world: CGPoint(x: worldX, y: 0))
            result.append(Line(a: CGPoint(x: screen.x, y: 0), b: CGPoint(x: screen.x, y: sceneSize.height)))
            worldX += worldStep
        }
        
        var worldY = round(worldTopLeft.y / worldStep) * worldStep
        if worldY < worldTopLeft.y {
           worldY += worldStep
        }
        
        while worldY < worldBottomRight.y {
            let screen = self.state.screen(world: CGPoint(x: 0, y: worldY))
            result.append(Line(a: CGPoint(x: 0, y: screen.y), b: CGPoint(x: sceneSize.width, y: screen.y)))
            worldY += worldStep
        }

        return result
    }
    
    private func anchors() -> [[CGPoint]] {
        var result = [[CGPoint]]()

        let R = 2 * Const.step
        let r = 0.25 * Const.step
        
        let ox = CGPoint(x: R, y: 0)
        let o = CGPoint.zero
        let oy = CGPoint(x: 0, y: R)
        result.append(self.state.screen(world: [ox, o, oy]))
        
        let oxa = ox + CGPoint(x: -r, y: 0.5 * r)
        let oxb = ox + CGPoint(x: -r, y: -0.5 * r)
        result.append(self.state.screen(world: [oxa, ox, oxb]))

        let oya = oy + CGPoint(x: -0.5 * r, y: -r)
        let oyb = oy + CGPoint(x: 0.5 * r, y: -r)
        result.append(self.state.screen(world: [oya, oy, oyb]))
        
        return result
    }

}


private extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
