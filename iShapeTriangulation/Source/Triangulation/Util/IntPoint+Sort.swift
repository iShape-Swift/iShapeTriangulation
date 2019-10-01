//
//  IntPoint+Sort.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

extension Array where Element == IntPoint {
    
    private struct SortData {
        let index: Int
        let factor: Int64
    }
    
    var sortIndices: [Int] {
        let n = self.count
        var dataList = Array<SortData>(repeating: SortData(index: 0, factor: 0), count: n)
        var i = 0
        while i < n {
            let p = self[i]
            dataList[i] = SortData(index: i, factor: p.bitPack)
            i += 1
        }
        
        dataList.sort(by: {a, b in a.factor < b.factor })
        
        var indices = Array<Int>(repeating: 0, count: n)
        i = 0
        while i < n {
            indices[i] = dataList[i].index
            i += 1
        }

        return indices
    }
    
}
