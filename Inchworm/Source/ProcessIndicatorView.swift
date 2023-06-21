//
//  ProcessIndicatorView.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

protocol ProcessIndicatorViewDelegate: AnyObject {
    func didActive(_ processIndicatorView: ProcessIndicatorView)
    func didTempReset(_ processIndicatorView: ProcessIndicatorView)
    func didRemoveTempReset(_ processIndicatorView: ProcessIndicatorView)
}

class ProcessIndicatorView: UIView {
    weak var delegate: ProcessIndicatorViewDelegate?
    var viewModel: ProcessIndicatorViewModel!
    
    private var progressLayer = CAShapeLayer()
    private var minusProgressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var progressNumberLayer = CATextLayer()
    private var iconLayer = CALayer()
    
    let trackColorVlue = UIColor(displayP3Red: 55.0 / 255.0,
                                 green: 45.0 / 255.0,
                                 blue: 9.0 / 255.0,
                                 alpha: 1)
    
    let minusTrackColorValue = UIColor(displayP3Red: 84.0 / 255.0,
                                       green: 84.0 / 255.0,
                                       blue: 84.0 / 255.0,
                                       alpha: 1)
    
    var sliderValueRangeType: SliderValueRangeType {
        viewModel.sliderValueRangeType
    }
    
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    var index = 0
    var active = false
    
    var progress: Float {
        get {
            viewModel.progress
        }
        
        set {
            viewModel.progress = newValue
        }
    }
    
    var status: IndicatorStatus = .initial {
        didSet {
            change(to: status)
        }
    }
    
    private var circlePath: UIBezierPath!
    
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
    
    override var frame: CGRect {
        didSet {
            setupUIFrames()
        }
    }
    
    init(frame: CGRect,
         viewModel: ProcessIndicatorViewModel,
         normalIconImage: CGImage? = nil,
         dimmedIconImage: CGImage? = nil) {
        super.init(frame: frame)
        
        self.viewModel = viewModel
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage

        createCircularPath()
        createProgressNumber()
        createIcon()
        setupUIFrames()
        
        viewModel.didSetProgress = { [weak self] progressValue in
            guard let self = self else { return }
            self.setProgress(ratio: self.viewModel.progress, value: progressValue)
        }
        
        viewModel.setDefaultProgress()
        
        if viewModel.progress == 0 {
            change(to: .initial)
        } else {
            change(to: .editingOthers)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUIFrames() {
        circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        let iconLayerLength = frame.width / 2
        
        iconLayer.frame = CGRect(x: frame.width / 2 - iconLayerLength / 2  , y: frame.height / 2 - iconLayerLength / 2 , width: iconLayerLength, height: iconLayerLength)
        
        progressNumberLayer.frame = CGRect(x: layer.bounds.origin.x, y: ((layer.bounds.height - progressNumberLayer.fontSize) / 2), width: layer.bounds.width, height: layer.bounds.height)
        
        layer.cornerRadius = self.frame.size.width/2
        trackLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
        minusProgressLayer.path = circlePath.reversing().cgPath
    }
    
    func initialActiveStatus() {
        active = true
        
        if progress != 0 {
            delegate?.didActive(self)
            status = .editingSelf
        }
    }
        
    func deactive() {
        active = false
        
        if status != .tempReset {
            if viewModel.progress == 0 {
                status = .initial
            } else {
                status = .editingOthers
            }
        }
    }
    
    @objc func handleTap() {
        if active {
            if status == .tempReset {
                status = .editingSelf
                delegate?.didRemoveTempReset(self)
            } else {
                status = .tempReset
                delegate?.didTempReset(self)
            }
        } else {
            active = true
            delegate?.didActive(self)
            
            if status == .tempReset {
                delegate?.didTempReset(self)
            }
            
            status = .editingSelf
        }
    }
        
    private func createIcon() {
        iconLayer.contentsGravity = .resizeAspect
        layer.addSublayer(iconLayer)
    }
    
    private func createCircularPath() {
        backgroundColor = UIColor.clear
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
    
    private func createProgressNumber() {
        progressNumberLayer = CATextLayer()
        progressNumberLayer.foregroundColor = UIColor.white.cgColor
        progressNumberLayer.contentsScale = UIScreen.main.scale
        progressNumberLayer.string = "0"
        progressNumberLayer.fontSize = 16
        progressNumberLayer.alignmentMode = .center
        
        layer.addSublayer(progressNumberLayer)
    }
    
    private func setProgress(ratio progressRatio: Float, value progressValue: Int) {
        status = .editingSelf
        
        if progressRatio > 0 {
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = true
            
            progressLayer.path = circlePath.cgPath
            progressColor = UIColor(displayP3Red: 247.0 / 255.0, green: 198.0 / 255.0, blue: 0, alpha: 1)
            trackColor = trackColorVlue
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.strokeEnd = abs(CGFloat(progressRatio))
            progressNumberLayer.foregroundColor = progressColor.cgColor
        } else {
            progressLayer.isHidden = true
            minusProgressLayer.isHidden = false
            
            minusProgressColor = .white
            trackColor = minusTrackColorValue
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
            minusProgressLayer.strokeEnd = abs(CGFloat(progressRatio))
            progressNumberLayer.foregroundColor = minusProgressColor.cgColor
        }
        
        trackLayer.strokeColor = trackColor.cgColor
        progressNumberLayer.string = "\(progressValue)"
    }
        
    private func change(to status: IndicatorStatus) {
        iconLayer.isHidden = false
        progressNumberLayer.isHidden = true
        trackLayer.strokeColor = trackColor.cgColor
        progressLayer.isHidden = true
        minusProgressLayer.isHidden = true
        
        switch status {
        case .initial:
            iconLayer.contents = normalIconImage
            trackLayer.strokeColor = UIColor.white.cgColor
        case .tempReset:
            iconLayer.contents = dimmedIconImage
            trackLayer.strokeColor = UIColor.gray.cgColor
        case .editingSelf:
            iconLayer.contents = normalIconImage
            trackLayer.strokeColor = (progress > 0 ? trackColorVlue : minusTrackColorValue).cgColor
            iconLayer.isHidden = true
            progressNumberLayer.isHidden = false
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = false
        case .editingOthers:
            iconLayer.contents = normalIconImage
            trackLayer.strokeColor = (progress > 0 ? trackColorVlue : minusTrackColorValue).cgColor
            iconLayer.isHidden = false
            progressNumberLayer.isHidden = true
            progressLayer.isHidden = false
            minusProgressLayer.isHidden = false
        }
    }
}

enum IndicatorStatus {
    case initial
    case tempReset
    case editingSelf
    case editingOthers
}
