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
    private let showIndices: Bool
    private let indices: [Index]
    @ObservedObject private var sceneState: SceneState

    
    private struct Index {
        let value: Int
        let point: CGPoint
    }
    
    init(sceneState: SceneState, shape: PlainShape, stroke: Color = .gray, lineWidth: CGFloat = 2, iGeom: IntGeom = .defGeom, showIndices: Bool = true) {
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.iGeom = iGeom
        self.showIndices = showIndices
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

        
        
        if showIndices {
            var j = 0
            let indexShift: CGFloat = 1
            var indices = [Index]()
            indices.reserveCapacity(points.count)
            for path in paths {
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
            }.strokedPath(.init(lineWidth: self.lineWidth)).foregroundColor(self.stroke)
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
