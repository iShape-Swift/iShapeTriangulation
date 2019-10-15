//
//  TestUtil.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 15.10.2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import iGeometry

struct TestUtil {
    
    
    public static func isCCW(points: [IntPoint], triangles: [Int]) -> Bool {
        let n = triangles.count
        var i = 0
        while i < n {
            let ai = triangles[i]
            let bi = triangles[i + 1]
            let ci = triangles[i + 2]
            
            let a = points[ai]
            let b = points[bi]
            let c = points[ci]

            if !isCCW_or_Line(a: a, b: b, c: c) {
                return false
            }
            i += 3
        }
        return true
    }
    
    private static func isCCW_or_Line(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        return m0 <= m1
    }
    
}
