//
//  ShapeVector.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeVector: CALayer {
    
    init(start: CGPoint, end: CGPoint, tip: CGFloat, lineWidth: CGFloat, strokeColor: CGColor, arrowColor: CGColor) {
        super.init()
        
        let line = ShapeLine(start: start, end: end, lineWidth: lineWidth, strokeColor: strokeColor)
        line.lineCap = .round
        self.addSublayer(line)
        
        let angle = atan2(end.y - start.y, end.x - start.x)
        let angleLeft = angle + CGFloat.pi * 9 / 10
        let angleRight = angle - CGFloat.pi * 9 / 10
        
        let leftPoint = end + CGPoint(radius: tip, angle: angleLeft)
        let rightPoint = end + CGPoint(radius: tip, angle: angleRight)
        
        let leftLine = ShapeLine(start: leftPoint, end: end, lineWidth: lineWidth, strokeColor: arrowColor)
        leftLine.lineCap = .round
        self.addSublayer(leftLine)
        
        let rightLine = ShapeLine(start: rightPoint, end: end, lineWidth: lineWidth, strokeColor: arrowColor)
        rightLine.lineCap = .round
        self.addSublayer(rightLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
}

