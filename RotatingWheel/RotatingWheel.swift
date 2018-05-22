//
//  RotatingWheel.swift
//  RotatingWheel
//
//  Created by Luca Kaufmann on 01/05/2018.
//  Copyright © 2018 Luca Kaufmann. All rights reserved.
//

import UIKit
import QuartzCore

class RotatingWheel: UIControl, RotatingWheelProtocol {
    
    var deltaAngle: CGFloat = 0.0
    weak var delegate: RotatingWheelProtocol?
    var container = UIView()
    var numberOfSections = Int()
    var startTransform: CGAffineTransform?
    
    convenience init() {
        self.init()
    }
    
    init(frame: CGRect, delegate: RotatingWheelProtocol, sections: Int) {
        super.init(frame: frame)
        self.numberOfSections = sections
        self.delegate = delegate
        self.drawWheel()
        self.drawRingFittingInsideView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawWheel() {
        container = UIView(frame: self.frame)
        
        let angleSize = 2*Double.pi / Double(numberOfSections)
        
        for i in 0..<numberOfSections {
            let im = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            im.backgroundColor = UIColor.clear
            im.text = String(i)
            im.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            im.layer.position = CGPoint(x: container.bounds.size.width / 2.0, y: container.bounds.size.height / 2.0)
            let angle = CGFloat(angleSize * Double(i))
            im.transform = CGAffineTransform(rotationAngle: angle)
            im.tag = i
            container.addSubview(im)
        }
        
        container.isUserInteractionEnabled = false
        self.addSubview(container)
    }
    
    internal func drawRingFittingInsideView()->() {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
    
    func drawCircle() {
        let path = UIBezierPath(ovalIn: self.frame)
        UIColor.green.setFill()
        path.fill()
    }
    
    func wheelDidChange(value: String) {
        return
    }
    
    func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
        let size = self.bounds.size
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt(dx*dx + dy*dy)
    }
    
    @objc func rotate() {
        let t = CGAffineTransform(rotationAngle: -0.78)
        container.transform = t
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let dist = calculateDistanceFromCenter(point: touchPoint)
        
        if dist < 40 || dist > 100 {
            print("ignoring tap")
            return false
        }
        let dx = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        
        deltaAngle = atan2(dy,dx)
        
        startTransform = container.transform
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        let dist = calculateDistanceFromCenter(point: pt)
        
        if dist < 20 || dist > 200 {
            print("ignoring tap")
            return false
        }
        let dx = pt.x - container.center.x
        let dy = pt.y - container.center.y
        let ang = atan2(dy, dx)
        let angleDifference = deltaAngle - ang
        container.transform = CGAffineTransform(rotationAngle: -angleDifference)
        
        return true
    }
    
    
}
