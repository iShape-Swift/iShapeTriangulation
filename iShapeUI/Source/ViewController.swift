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
    private let scene = ComplexDelaunayTriangulationScene()
//    private let scene = MotoneDelaunayTriangulationScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if var frame = self.view.window?.frame {
            frame.size = CGSize(width: 600, height: 800)
            self.view.window?.setFrame(frame, display: true)
        }
        
        canvasView.add(shape: scene)
        self.canvasView.testName.stringValue = scene.getName()
        canvasView.onMouseMoved = { event in
            let point = self.canvasView.convert(point: event.locationInWindow)
            self.scene.mouseMove(point: point)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene.mouseDown(point: point)
    }
    
    
    override func mouseUp(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene.mouseUp(point: point)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = self.canvasView.convert(point: event.locationInWindow)
        self.scene.mouseDragged(point: point)
    }

    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 124 || theEvent.keyCode == 49 || theEvent.keyCode == 36 {
            scene.next()
            self.canvasView.testName.stringValue = scene.getName()
        } else if theEvent.keyCode == 123 {
            scene.back()
            self.canvasView.testName.stringValue = scene.getName()
        }
    }
    
}
