//
//  CircularProgressView.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var minusProgressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var progressNumberLayer = CATextLayer()
    fileprivate var iconLayer = CALayer()
    
    var limitNumber = 40
    
    private lazy var circlePath: UIBezierPath = {
        UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
    } ()
                
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
        createProgressNumber()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var minusProgressColor = UIColor.white {
        didSet {
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 2.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 2.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        minusProgressLayer.path = circlePath.reversing().cgPath
        minusProgressLayer.fillColor = UIColor.clear.cgColor
        minusProgressLayer.strokeColor = minusProgressColor.cgColor
        minusProgressLayer.lineWidth = 2.0
        minusProgressLayer.strokeEnd = 0.0
        layer.addSublayer(minusProgressLayer)
    }
    
    func createProgressNumber() {
        progressNumberLayer = CATextLayer()
        progressNumberLayer.foregroundColor = UIColor.white.cgColor
        progressNumberLayer.contentsScale = UIScreen.main.scale
        progressNumberLayer.string = "0"
        progressNumberLayer.fontSize = 16
        
        progressNumberLayer.alignmentMode = .center
        progressNumberLayer.frame = CGRect(x: self.layer.bounds.origin.x, y: ((self.layer.bounds.height - progressNumberLayer.fontSize) / 2), width: self.layer.bounds.width, height: self.layer.bounds.height)

        layer.addSublayer(progressNumberLayer)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }

    func setProgress(_ progress: Float) {
        if progress > 0 {
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = true
            
            progressLayer.path = circlePath.cgPath
            progressColor = UIColor(displayP3Red: 247.0 / 255.0, green: 198.0 / 255.0, blue: 0, alpha: 1)
            trackColor = UIColor(displayP3Red: 55.0 / 255.0, green: 45.0 / 255.0, blue: 9.0 / 255.0, alpha: 1)
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.strokeEnd = abs(CGFloat(progress))
            progressNumberLayer.foregroundColor = progressColor.cgColor
        } else {
            progressLayer.isHidden = true
            minusProgressLayer.isHidden = false
            
            minusProgressColor = UIColor(displayP3Red: 203.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
            trackColor = UIColor(displayP3Red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
            minusProgressLayer.strokeEnd = abs(CGFloat(progress))
            progressNumberLayer.foregroundColor = minusProgressColor.cgColor
        }
        
        trackLayer.strokeColor = trackColor.cgColor
        progressNumberLayer.string = "\(Int(progress * 40))"
    }
}
