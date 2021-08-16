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
    
    var body: some View {
        NavigationView {
            MenuView(state: self.state).frame(width: 200)
            MainView(state: self.state).frame(minWidth: 30)
        }.frame(minWidth: 250, maxWidth: .greatestFiniteMagnitude, minHeight: 200, maxHeight: .greatestFiniteMagnitude)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
