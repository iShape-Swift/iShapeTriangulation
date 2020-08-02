//
//  ShapeLinePolygon.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import Cocoa

final class ShapeLinePolygon: CALayer {
    
    init(points: [CGPoint], lineWidth: CGFloat, color: CGColor) {
        super.init()
        let n = points.count
        guard n > 1 else {
            return
        }

        var a = points[n - 1]
        
        for i in 0..<n {
            let b = points[i]
            self.addSublayer(ShapeLine(start: a, end: b, lineWidth: lineWidth, strokeColor: color))
            a = b
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
}
