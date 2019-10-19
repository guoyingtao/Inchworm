//
//  ProcessIndicatorView.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

protocol ProcessIndicatorViewDelegate {
    func didActive(_ processIndicatorView: ProcessIndicatorView)
}

class ProcessIndicatorView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var minusProgressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var progressNumberLayer = CATextLayer()
    fileprivate var iconLayer = CALayer()
    
    var limitNumber = 30
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    var index = 0
    
    var active = false {
        didSet {
            if active {
                delegate?.didActive(self)
            }
        }
    }
    
    var progress: Float = 0.0 {
        didSet {
            setProgress(progress)
        }
    }
    
    var status: IndicatorStatus = .initial
    var delegate: ProcessIndicatorViewDelegate?
    
    private lazy var circlePath: UIBezierPath = {
        UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
    } ()
    
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
    
    init(frame: CGRect, limitNumber: Int = 30, normalIconImage: CGImage? = nil, dimmedIconImage: CGImage? = nil) {
        super.init(frame: frame)
        
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
        
        createCircularPath()
        createProgressNumber()
        createIcon()
        change(to: .initial)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleActivited(notification:)), name: .ProgressIndicatorActivated, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func handleActivited(notification: Notification) {
        guard let object = notification.object as? ProcessIndicatorView else {
            return
        }
        
        active = (self === object)
    }
    
    @objc func handleTap() {
        if active {
            if status == .tempReset {
                status = .editing
            } else {
                status = .tempReset
            }
        } else {
            active = true
        }
        
        NotificationCenter.default.post(name: .ProgressIndicatorActivated, object: self)
    }
        
    fileprivate func createIcon() {
        let iconLayerLength = frame.width / 2
        
        iconLayer.frame = CGRect(x: frame.width / 2 - iconLayerLength / 2  , y: frame.height / 2 - iconLayerLength / 2 , width: iconLayerLength, height: iconLayerLength)
        iconLayer.contentsGravity = .resizeAspect
        layer.addSublayer(iconLayer)
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
        
        progressLayer = getProgressLayer(by: circlePath.cgPath, and: progressColor.cgColor)
        layer.addSublayer(progressLayer)
        
        minusProgressLayer = getProgressLayer(by: circlePath.reversing().cgPath, and: minusProgressColor.cgColor)
        layer.addSublayer(minusProgressLayer)
    }
    
    private func getProgressLayer(by path: CGPath, and color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = 2.0
        layer.strokeEnd = 0.0
        
        return layer
    }
    
    fileprivate func createProgressNumber() {
        progressNumberLayer = CATextLayer()
        progressNumberLayer.foregroundColor = UIColor.white.cgColor
        progressNumberLayer.contentsScale = UIScreen.main.scale
        progressNumberLayer.string = "0"
        progressNumberLayer.fontSize = 16
        
        progressNumberLayer.alignmentMode = .center
        progressNumberLayer.frame = CGRect(x: self.layer.bounds.origin.x, y: ((self.layer.bounds.height - progressNumberLayer.fontSize) / 2), width: self.layer.bounds.width, height: self.layer.bounds.height)
        
        layer.addSublayer(progressNumberLayer)
    }
    
    private func setProgress(_ progress: Float) {
        change(to: .editing)
        
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
        progressNumberLayer.string = "\(Int(progress * Float(limitNumber)))"
    }
    
    func change(to status: IndicatorStatus) {
        iconLayer.isHidden = false
        progressNumberLayer.isHidden = true
        
        switch status {
        case .initial:
            iconLayer.contents = normalIconImage
        case .tempReset:
            iconLayer.contents = dimmedIconImage
        case .editing:
            iconLayer.isHidden = true
            progressNumberLayer.isHidden = false
        case .changed:
            print("changed")
        }
    }
}

extension Notification.Name {
    static let ProgressIndicatorActivated
                = NSNotification.Name("ProgressIndicatorActivated")
}

enum IndicatorStatus {
    case initial
    case tempReset
    case editing
    case changed
}
