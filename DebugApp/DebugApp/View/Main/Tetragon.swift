//
//  Tetragon.swift
//  DebugApp
//
//  Created by Nail Sharipov on 25.05.2023.
//  Copyright © 2023 Nail Sharipov. All rights reserved.
//

import iGeometry

struct Tetragon {
    
    static func isContain(a: IntPoint, b: IntPoint, c: IntPoint, d: IntPoint, p: IntPoint) -> Bool {
        let ab = a - b
        let bc = b - c
        let cd = c - d
        let da = d - a

        let da_ab = da.crossProduct(point: ab)
        
        // dab
        if da_ab > 0 {
            return isTriangleContain(a: b, b: c, c: d, p: p) && !isTriangleContain(a: d, b: a, c: b, p: p)
        }
        
        let ab_bc = ab.crossProduct(point: bc)
        
        // abc
        if ab_bc > 0 {
            return isTriangleContain(a: c, b: d, c: a, p: p) && !isTriangleContain(a: a, b: b, c: c, p: p)
        }
        
        let bc_cd = bc.crossProduct(point: cd)
        
        // bcd
        if bc_cd > 0 {
            return isTriangleContain(a: d, b: a, c: b, p: p) && !isTriangleContain(a: b, b: c, c: d, p: p)
        }

        
        let cd_da = cd.crossProduct(point: da)
        
        // cda
        if cd_da > 0 {
            return isTriangleContain(a: a, b: b, c: c, p: p) && !isTriangleContain(a: c, b: d, c: a, p: p)
        }

        // concave
        return isTriangleContain(a: a, b: b, c: c, p: p) || isTriangleContain(a: c, b: d, c: a, p: p)
    }

    private static func isTriangleContain(a: IntPoint, b: IntPoint, c: IntPoint, p: IntPoint) -> Bool {
        let q0 = (p - b).crossProduct(point: a - b)
        let q1 = (p - c).crossProduct(point: b - c)
        let q2 = (p - a).crossProduct(point: c - a)
        
        let has_neg = q0 <= 0 || q1 <= 0 || q2 <= 0
        let has_pos = q0 >= 0 || q1 >= 0 || q2 >= 0
        
        return !(has_neg && has_pos)
    }
    
}
