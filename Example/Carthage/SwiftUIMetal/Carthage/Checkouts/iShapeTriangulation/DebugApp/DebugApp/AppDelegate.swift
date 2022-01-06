//
//  AppDelegate.swift
//  DebugApp
//
//  Created by Nail Sharipov on 02.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    final class CustomWindow: NSWindow {
        
        var inputSystem: InputSystem?
        
        override func keyDown(with: NSEvent) {
            if !(self.inputSystem?.onKeyDown(keyCode: with.keyCode) ?? false) {
                super.keyDown(with: with)
            }
        }
    }
    
    private var window: CustomWindow?
    private let colorSchema = ColorSchema()
    private let inputSystem = InputSystem()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let contentView = ContentView().environmentObject(colorSchema).environmentObject(inputSystem)

        // Create the window and set the content view.
        let aWindow = CustomWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        aWindow.center()
        aWindow.setFrameAutosaveName("Main Window")
        aWindow.contentView = NSHostingView(rootView: contentView)
        aWindow.makeKeyAndOrderFront(nil)
        aWindow.inputSystem = inputSystem
        
        self.window = aWindow
    }
}
