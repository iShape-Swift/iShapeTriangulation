//
//  IntPoint+Monotone.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import iGeometry

extension Array where Element == IntPoint {
    
    var isMonotone: Bool {
        let n = self.count
        guard n > 2 else { return false }
        
        var a = self[n - 2].bitPack
        var b = self[n - 1].bitPack
        
        var i = 0
        var leftCount = 0
        var rightCount = 0
        repeat {
            let c = self[i].bitPack
            
            if a > b && b < c {
                leftCount += 1
            } else if a < b && b > c {
                rightCount += 1
            }
            
            a = b
            b = c
            
            i += 1
        } while i < n
        
        return leftCount == 1 && rightCount == 1
    }
}
