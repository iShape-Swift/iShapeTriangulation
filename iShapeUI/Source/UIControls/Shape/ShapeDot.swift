//
//  ShapeDot.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeDot: CAShapeLayer {
    
    init(position: CGPoint, radius: CGFloat, color: CGColor) {
        super.init()
        
        let linePath = CGMutablePath()
        linePath.addEllipse(in: CGRect(x: position.x - 0.5 * radius, y: position.y - 0.5 * radius, width: radius, height: radius))
        
        self.path = linePath
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

