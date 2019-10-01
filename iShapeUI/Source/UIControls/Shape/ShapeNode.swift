//
//  ShapeNode.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 04/08/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeNode: CALayer {
    
    init(position: CGPoint, radius: CGFloat, text: String, color: CGColor) {
        super.init()
        
        self.position = position
        let dot = ShapeDot(position: .zero, radius: radius, color: color)
        self.addSublayer(dot)

        let font = NSFont.systemFont(ofSize: 32)
        
        let shapeText = ShapeText(text: text, font: font, position: CGPoint(x: 0, y: 1.5), pin: .zero, lineWidth: 0.1, color: NSColor.blue.cgColor, strokeColor: Colors.lightGray)
        
        self.addSublayer(shapeText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
}
