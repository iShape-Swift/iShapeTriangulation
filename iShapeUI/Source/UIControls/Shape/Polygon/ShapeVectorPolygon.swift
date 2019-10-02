//
//  ShapePolygon.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ShapeVectorPolygon: CALayer {
    
    init(points: [CGPoint], shift: CGFloat, tip: CGFloat, lineWidth: CGFloat, color: CGColor, indexShift: CGFloat, data: [String]?) {
        super.init()
        let n = points.count
        guard n > 1 else {
            return
        }
        
        let font = NSFont.systemFont(ofSize: 32)
        
        var normal = ShapeVectorPolygon.normal(a: points[n - 2], b: points[n - 1], c: points[0])
        var start = points[n - 1] + shift * normal
        
        for i in 0..<n {
            let a = points[(i - 1 + n) % n]
            let b = points[i]
            let c = points[(i + 1) % n]
            normal = ShapeVectorPolygon.normal(a: a, b: b, c: c)
            let end = b + shift * normal
            
            self.addSublayer(ShapeVector(start: start, end: end, tip: tip, lineWidth: lineWidth, strokeColor: color, arrowColor: color))
            start = end
            
            if let data = data {
                let fontPoint = b + indexShift * normal
                let text = data[i]
                
                let shapeText = ShapeText(text: text, font: font, position: fontPoint, pin: b, lineWidth: 0.1, color: NSColor.black.cgColor, strokeColor: Colors.lightGray)
                
                self.addSublayer(shapeText)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private static func normal(a: CGPoint, b: CGPoint, c: CGPoint) -> CGPoint {
        guard (b - a).magnitude > 0.00000000000000000001 && (c - b).magnitude > 0.00000000000000000001 else {
            return CGPoint(x: 1, y: 0)
        }
        let ab = (b - a).normalize
        let bc = (c - b).normalize

        let abN = CGPoint(x: ab.y, y: -ab.x)
        let bcN = CGPoint(x: bc.y, y: -bc.x)
        
        let sum = abN + bcN
        if sum.magnitude < 0.00000000000000000001 {
            return CGPoint(x: -ab.x, y: -ab.y)
        }
        
        return sum.normalize
    }
    
}
