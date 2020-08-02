//
//  ShapeLine.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeLine: CAShapeLayer {
    
    init(start: CGPoint, end: CGPoint, lineWidth: CGFloat, strokeColor: CGColor) {
        super.init()
        
        let linePath = CGMutablePath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        
        self.path = linePath
        self.fillColor = nil
        self.opacity = 1.0
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
}
