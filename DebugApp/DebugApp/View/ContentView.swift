//
//  ContentView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 02.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private let state = ContentState()
    private let inputSystem: InputSystem
    
    init(inputSystem: InputSystem) {
        self.inputSystem = inputSystem
    }
    
    var body: some View {
        NavigationView {
            MenuView(state: self.state).frame(width: 150)
            MainView(state: self.state, inputSystem: inputSystem).frame(minWidth: 30)
        }.frame(minWidth: 200, maxWidth: .greatestFiniteMagnitude, minHeight: 200, maxHeight: .greatestFiniteMagnitude)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(inputSystem: InputSystem())
    }
}
