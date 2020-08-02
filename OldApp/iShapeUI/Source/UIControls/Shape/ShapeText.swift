//
//  ShapeText.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeText: CALayer {
    
    init(text: String, font: NSFont, position: CGPoint, pin: CGPoint, lineWidth: CGFloat, color: CGColor, strokeColor: CGColor) {
        super.init()
        
        let a = font.pointSize
        
        
        let size = text.boundingRect(with: CGSize(width: 10 * a, height: 2 * a), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font]).size
        
        let rect = CGRect(x: position.x - 0.5 * size.width, y: position.y - 0.5 * size.height, width: size.width, height: size.height)
        
        let textLayer = CATextLayer()
        textLayer.font = font
        textLayer.fontSize = a
        textLayer.foregroundColor = color
        textLayer.string = text
        textLayer.frame = rect
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.transform = CATransform3DMakeScale(0.05, 0.05, 1.0)
        
        self.addSublayer(ShapeLine(start: position, end: pin, lineWidth: lineWidth, strokeColor: strokeColor))
        self.addSublayer(textLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
}
