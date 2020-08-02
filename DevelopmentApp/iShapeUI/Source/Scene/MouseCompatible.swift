//
//  MouseCompatible.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation

protocol MouseCompatible {
    
    func mouseDown(point: CGPoint)
    
    func mouseUp(point: CGPoint)
    
    func mouseDragged(point: CGPoint)
    
    func mouseMove(point: CGPoint)
    
}

extension MouseCompatible {
    func mouseMove(point: CGPoint)  {
        
    }
}
