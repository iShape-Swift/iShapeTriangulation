//
//  ShapeArea.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 28/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeArea: CAShapeLayer {
    
    init(points: [CGPoint], color: CGColor) {
        super.init()
        
        let path = CGMutablePath()
        path.move(to: points[0])
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        path.closeSubpath()

        self.path = path
        self.fillColor = color
        self.opacity = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
}
