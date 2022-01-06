//
//  PathShapeView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 07.01.2021.
//  Copyright © 2021 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry

struct PathShapeView: View {

    private let paths: [[CGPoint]]
    private let stroke: Color
    private let lineWidth: CGFloat
    private let showIndices: Bool
    private let indices: [Index]
    @ObservedObject private var sceneState: SceneState

    
    private struct Index {
        let value: Int
        let point: CGPoint
    }
    
    init(sceneState: SceneState, paths: [[Point]], stroke: Color = .gray, lineWidth: CGFloat = 2, showIndices: Bool = true) {
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.showIndices = showIndices
        self.sceneState = sceneState
        self.paths = paths.map({ $0.cgPoints })

        if showIndices {
            var j = 0
            let indexShift: CGFloat = 1
            var indices = [Index]()
            indices.reserveCapacity(paths.first?.count ?? 10)
            for path in self.paths {
                let n = path.count

                for i1 in 0..<n {
                    let i0 = (i1 - 1 + n) % n
                    let i2 = (i1 + 1) % n
                    
                    let p0 = path[i0]
                    let p1 = path[i1]
                    let p2 = path[i2]

                    let normal = CGPoint.normal(a: p0, b: p1, c: p2)
                    let point = p1 - indexShift * normal
                    
                    indices.append(Index(value: j, point: point))
                    
                    j += 1
                }
            }
            self.indices = indices
        }  else {
            self.indices = []
        }
    }

    var body: some View {
        return ZStack {
            Path { path in
                for points in paths {
                    let screenPoints = sceneState.screen(world: points)
                    path.addLines(screenPoints)
                    path.closeSubpath()
                }
            }.strokedPath(.init(lineWidth: self.lineWidth, lineCap: .round)).foregroundColor(self.stroke)
            ForEach(self.indices, id: \.value) { index in
                Text("\(index.value)").position(self.sceneState.screen(world: index.point)).foregroundColor(.black)
            }
        }
    }
    
}

private extension CGPoint {

    static private let epsilon: CGFloat = 0.00000000000000000001
    
    static func normal(a: CGPoint, b: CGPoint, c: CGPoint) -> CGPoint {
        guard (b - a).magnitude > CGPoint.epsilon && (c - b).magnitude > CGPoint.epsilon else {
            return CGPoint(x: 1, y: 0)
        }
        let ab = (b - a).normalize
        let bc = (c - b).normalize

        let abN = CGPoint(x: ab.y, y: -ab.x)
        let bcN = CGPoint(x: bc.y, y: -bc.x)
        
        let sum = abN + bcN
        if sum.magnitude < CGPoint.epsilon {
            return CGPoint(x: -ab.x, y: -ab.y)
        }
        
        return sum.normalize
    }
    
}
