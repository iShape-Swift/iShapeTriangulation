//
//  ShapeCircle.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 10/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeCircle: CAShapeLayer {
    
    init(position: CGPoint, radius: CGFloat, color: CGColor, depth: CGFloat) {
        super.init()
        
        let linePath = CGMutablePath()
        linePath.addEllipse(in: CGRect(x: position.x - radius, y: position.y - radius, width: 2.0 * radius, height: 2.0 * radius))
        
        self.path = linePath
        self.fillColor = .clear
        self.lineWidth = depth
        self.strokeColor = color
        self.opacity = 1.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
}
