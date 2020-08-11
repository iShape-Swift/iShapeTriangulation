//
//  MenuView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 03.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct MenuView: View {

    @ObservedObject private var state: ContentState
    private let data = ContentState.Test.allCases
    
    init(state: ContentState) {
        self.state = state
    }
    
    var body: some View {
        List(self.data, id: \.self) { test in
            MenuRowView(test: test, isSelected: self.state.current == test)
                .gesture(TapGesture().onEnded { _ in
                    self.state.current = test
                }
            )
        }
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(state: ContentState())
    }
}
