//
//  ContentState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 06.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

final class ContentState: ObservableObject {
    
    enum Test: String, CaseIterable {
        case plainMonotone
        case delaunayMonotone
        case plainComplex
        case delaunayComplex
        case polygon
        case extraPoint
        case centroidNet
        case tessellation
        case delaunayCondition
        case tessellationCondition
        case tetragonIntersection
    }
    
    @Published var current: Test = .plainMonotone
}
