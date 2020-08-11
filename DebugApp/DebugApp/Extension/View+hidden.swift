//
//  View+hidden.swift
//  DebugApp
//
//  Created by Nail Sharipov on 10.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI
extension View {

    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder func remove(_ value: Bool) -> some View {
        if !value {
            self
        }
    }
}
