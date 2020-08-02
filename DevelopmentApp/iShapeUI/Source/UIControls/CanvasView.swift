//
//  CanvasView.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

final class CanvasView: NSView {
    
    private var transform: CATransform3D
    private static let canvasSize: CGFloat = 10
    
    private (set) var testName: NSTextField = {
        let textField = NSTextField()
        textField.isEditable = false
        textField.stringValue = "none"
        textField.alignment = .center
        textField.isBordered = false
        return textField
    }()
    
    private (set) var testList: NSPopUpButton = {
        let button = NSPopUpButton()
        let layer = CALayer()
        layer.backgroundColor = NSColor.black.cgColor
        button.layer = layer

        return button
    }()
    var onMouseMoved: ((NSEvent) -> ())?
    
    var trackingArea : NSTrackingArea?
    
    override func updateTrackingAreas() {
        if trackingArea != nil {
            self.removeTrackingArea(trackingArea!)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }
    
    override func mouseMoved(with event: NSEvent) {
        onMouseMoved?(event)
    }
    
    override init(frame frameRect: NSRect) {
        self.transform = CanvasView.calculateCurrentTransform(rect: frameRect)
        super.init(frame: frameRect)
        wantsLayer = true
        self.layer?.backgroundColor = Colors.white
        self.addSubview(testName)
        self.addSubview(testList)
    }
    
    required init?(coder decoder: NSCoder) {
        self.transform = CATransform3DIdentity
        super.init(coder: decoder)
        wantsLayer = true
        self.layer?.backgroundColor = Colors.white
        self.addSubview(testName)
        self.addSubview(testList)
    }
    
    override func layout() {
        super.layout()
        let size = self.bounds.size
        let width: CGFloat = 160
        let height: CGFloat = 20

        self.transform = CanvasView.calculateCurrentTransform(rect: self.bounds)
        
        guard let layers = self.layer?.sublayers else {
            return
        }
        
        for layer in layers {
            layer.transform = self.transform
        }
        
        self.testList.frame = CGRect(x: 0.5 * (size.width - width), y: size.height - height, width: width, height: height)
        self.testName.frame = CGRect(x: 0.5 * (size.width - width), y: size.height - 2 * height, width: width, height: height)
    }
    
    private static func calculateCurrentTransform(rect: CGRect) -> CATransform3D {
        return CATransform3DScale(CATransform3DMakeTranslation(0.5 * rect.width, 0.5 * rect.height, 0), canvasSize, canvasSize, 1.0)
    }
    
    
    func convert(point: NSPoint) -> CGPoint {
        let point = self.convert(point, to: nil)
        let rect = self.frame
        let x = (point.x / rect.width - 0.5) * rect.width * CanvasView.canvasSize * 0.01
        let y = (point.y / rect.height - 0.5) * rect.height * CanvasView.canvasSize * 0.01
        
        return CGPoint(x: x, y: y)
    }
    
    func add(shape: CALayer) {
        shape.transform = transform
        self.layer?.insertSublayer(shape, at: 0)
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
}
