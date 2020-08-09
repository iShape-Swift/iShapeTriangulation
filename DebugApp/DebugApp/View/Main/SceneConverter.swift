//
//  SceneConverter.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import Foundation

protocol SceneConverter {
    func screen(world: CGPoint) -> CGPoint
    func screen(world: [CGPoint]) -> [CGPoint]
}
