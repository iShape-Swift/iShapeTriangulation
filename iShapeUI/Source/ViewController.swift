//
//  ViewController.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class ViewController: NSViewController {

    private var canvasView: CanvasView {
        get {
            return self.view as! CanvasView
        }
    }
    
//    private let scene = SplitScene()
//    private let scene = MotoneBreakScene()
//    private let scene = PlainTriangulationScene()
//    private let scene = DelaunayAssessmentScene()
    private var scene: (CALayer & MouseCompatible & SceneNavigation)?
//    private let scene = MotoneDelaunayTriangulationScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if var frame = self.view.window?.frame {
            frame.size = CGSize(width: 600, height: 800)
            self.view.window?.setFrame(frame, display: true)
        }
        self.setupPopUpButton()
    }

    private func setupPopUpButton() {
        let popUpButton = canvasView.testList
        popUpButton.addItems(withTitles: ["Complex Plain", "Complex Delaunay", "Monotone Plain", "Monotone Delaunay", "DelaunayTest"])
        popUpButton.selectItem(at: 0)
        popUpButton.action = #selector(didPickScene)
        popUpButton.target = self
        self.selectScene(index: 0)
    }
    
    @objc private func didPickScene(sender: NSPopUpButton) {
        self.selectScene(index: sender.indexOfSelectedItem)
    }
    
    private func selectScene(index: Int) {
        self.scene?.removeFromSuperlayer()
        let newScene: CALayer & MouseCompatible & SceneNavigation
        switch index {
        case 0:
            newScene = ComplexPlainTriangulationScene()
        case 1:
            newScene = ComplexDelaunayTriangulationScene()
        case 2:
            newScene = MotonePlainTriangulationScene()
        case 3:
            newScene = MotoneDelaunayTriangulationScene()
        default:
            newScene = DelaunayAssessmentScene()
        }
        
        canvasView.add(shape: newScene)
        self.canvasView.testName.stringValue = newScene.getName()
        canvasView.onMouseMoved = { event in
            let point = self.canvasView.convert(point: event.locationInWindow)
            self.scene?.mouseMove(point: point)
        }
        
        self.scene = newScene
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene?.mouseDown(point: point)
    }
    
    
    override func mouseUp(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene?.mouseUp(point: point)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene?.mouseDragged(point: point)
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 124 || theEvent.keyCode == 49 || theEvent.keyCode == 36 {
            scene?.next()
            self.canvasView.testName.stringValue = scene?.getName() ?? ""
        } else if theEvent.keyCode == 123 {
            scene?.back()
            self.canvasView.testName.stringValue = scene?.getName() ?? ""
        }
    }
    
}
