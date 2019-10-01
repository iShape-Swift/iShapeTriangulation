//
//  ShapeTriangle.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 18/08/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeTriangle: CAShapeLayer {
    
    init(points: [CGPoint], text: String, color: CGColor, lineWidth: CGFloat = 0.25) {
        super.init()
        
        //let linePath = CGMutablePath()
        let n = points.count
        var start = points[n - 1]
        var middle: CGPoint = .zero
        for i in 0..<n {
            let end = points[i]
            self.addSublayer(ShapeLine(start: start, end: end, lineWidth: lineWidth, strokeColor: color))
            start = end
            middle.x += end.x
            middle.y += end.y
        }
        
        middle.x = middle.x / CGFloat(n)
        middle.y = middle.y / CGFloat(n)

        //self.path = linePath
        self.fillColor = color
        self.opacity = 1.0
        
        let font = NSFont.systemFont(ofSize: 28)
        self.addSublayer(ShapeText(text: text, font: font, position: middle, pin: middle, lineWidth: lineWidth, color: color, strokeColor: color))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }

}
