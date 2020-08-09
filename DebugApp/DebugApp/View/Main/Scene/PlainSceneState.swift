//
//  PlainSceneState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
import iGeometry
import iShapeTriangulation

final class PlainSceneState: ObservableObject, Scene {

    private static let key = String(describing: PlainSceneState.self)
    private var pageIndex: Int = UserDefaults.standard.integer(forKey: PlainSceneState.key)
    
    @Published var data: [Point] = []
    
    init() {
        self.data = MonotoneTests.data[self.pageIndex]
    }
    
    func onNext() {
        let n = MonotoneTests.data.count
        self.pageIndex = (pageIndex + 1) % n
        UserDefaults.standard.set(pageIndex, forKey: PlainSceneState.key)
        self.data = MonotoneTests.data[self.pageIndex]
    }
    
    func onPrev() {
        let n = MonotoneTests.data.count
        self.pageIndex = (pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: PlainSceneState.key)
        self.data = MonotoneTests.data[self.pageIndex]
    }
}
