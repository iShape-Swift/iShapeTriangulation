//
//  ShapeCoordinatSystem.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeCoordinatSystem: CALayer {
    
    init(position: CGPoint, length: CGFloat, tip: CGFloat, lineWidth: CGFloat, strokeColor: CGColor) {
        super.init()
        
        let vecOx = ShapeVector(start: position, end: position + CGPoint(radius: length, angle: 0), tip: tip, lineWidth: lineWidth, strokeColor: strokeColor, arrowColor: strokeColor)
        let vecOy = ShapeVector(start: position, end: position + CGPoint(radius: length, angle: 0.5 * CGFloat.pi), tip: tip, lineWidth: lineWidth, strokeColor: strokeColor, arrowColor: strokeColor)
        
        self.addSublayer(vecOx)
        self.addSublayer(vecOy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
}
