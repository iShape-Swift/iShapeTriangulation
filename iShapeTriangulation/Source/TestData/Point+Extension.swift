//
//  Point+Extension.swift
//  iGeometry
//
//  Created by Nail Sharipov on 16.05.2020.
//

#if DEBUG

import Foundation
import iGeometry

private extension Array where Element == Point {
    
    func scale(m: Float) -> [Point] {
        var result = Array(repeating: .zero, count: self.count)
        for i in 0..<self.count {
            let p = self[i]
            result[i] = Point(x: p.x * m, y: p.y * m)
        }
        return result
    }

}

extension Array where Element == [Point] {
    
    func scale(m: Float) -> [[Point]] {
        var result = [[Point]]()
        for points in self {
            result.append(points.scale(m: m))
        }
        return result
    }

}

#endif
