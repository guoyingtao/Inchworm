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
    
    private var positiveProgressLayer = CAShapeLayer()
    private var minusProgressLayer = CAShapeLayer()
    private var progressBaseTrackLayer = CAShapeLayer()
    private var progressNumberLayer = CATextLayer()
    private var indicatorIconLayer = CALayer()
    
    let positiveTrackColorVlue = UIColor(displayP3Red: 55.0 / 255.0,
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
    var isActive: Bool {
        get {
            viewModel.isActive
        }
        
        set {
            viewModel.isActive = newValue
        }
    }
    
    var progress: Float {
        get {
            viewModel.progress
        }
        
        set {
            viewModel.progress = newValue
        }
    }
        
    private var circlePath: UIBezierPath!
    
    var positiveProgressColor = UIColor.white {
        didSet {
            positiveProgressLayer.strokeColor = positiveProgressColor.cgColor
        }
    }
    
    var minusProgressColor = UIColor.white {
        didSet {
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
        }
    }
    
    var progressBaseTrackColor = UIColor.white {
        didSet {
            progressBaseTrackLayer.strokeColor = progressBaseTrackColor.cgColor
        }
    }
    
    override var frame: CGRect {
        didSet {
            layoutUIs()
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

        createUIs()
        setupViewModel()
        makeTappable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createUIs() {
        createCircularProgressIndicator()
        createProgressNumberIndicator()
        createIndicatorIcon()
        layoutUIs()
    }
    
    func layoutUIs() {
        circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        let iconLayerLength = frame.width / 2
        
        indicatorIconLayer.frame = CGRect(x: frame.width / 2 - iconLayerLength / 2  , y: frame.height / 2 - iconLayerLength / 2 , width: iconLayerLength, height: iconLayerLength)
        
        progressNumberLayer.frame = CGRect(x: layer.bounds.origin.x, y: ((layer.bounds.height - progressNumberLayer.fontSize) / 2), width: layer.bounds.width, height: layer.bounds.height)
        
        layer.cornerRadius = self.frame.size.width/2
        progressBaseTrackLayer.path = circlePath.cgPath
        positiveProgressLayer.path = circlePath.cgPath
        minusProgressLayer.path = circlePath.reversing().cgPath
    }
    
    func setupViewModel() {
        viewModel.didSetProgress = { [weak self] progressValue in
            guard let self = self else { return }
            self.setProgress(ratio: self.viewModel.progress, value: progressValue)
        }
        
        viewModel.didSetStatus = { [weak self] status in
            self?.change(to: status)
        }
        
        viewModel.initialize()
    }
    
    func initialActiveStatus() {
        isActive = true
        
        if progress != 0 {
            delegate?.didActive(self)
            viewModel.status = .editing
        }
    }
        
    func deactive() {
        viewModel.deactive()        
    }
    
    func makeTappable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        if isActive {
            if viewModel.status == .editing {
                viewModel.status = .reset
                delegate?.didTempReset(self)
            } else {
                viewModel.status = .editing
                delegate?.didRemoveTempReset(self)
            }
        } else {
            isActive = true
            delegate?.didActive(self)
            
            if viewModel.status == .reset {
                delegate?.didTempReset(self)
            } else {
                viewModel.status = .editing
            }
        }
    }
        
    private func createIndicatorIcon() {
        indicatorIconLayer.contentsGravity = .resizeAspect
        layer.addSublayer(indicatorIconLayer)
    }
    
    private func createCircularProgressIndicator() {
        backgroundColor = UIColor.clear
        progressBaseTrackLayer.fillColor = UIColor.clear.cgColor
        progressBaseTrackLayer.strokeColor = progressBaseTrackColor.cgColor
        progressBaseTrackLayer.lineWidth = 2.0
        progressBaseTrackLayer.strokeEnd = 1.0
        layer.addSublayer(progressBaseTrackLayer)
        
        positiveProgressLayer = getProgressLayer(by: circlePath.cgPath, and: positiveProgressColor.cgColor)
        layer.addSublayer(positiveProgressLayer)
        
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
    
    private func createProgressNumberIndicator() {
        progressNumberLayer = CATextLayer()
        progressNumberLayer.foregroundColor = UIColor.white.cgColor
        progressNumberLayer.contentsScale = UIScreen.main.scale
        progressNumberLayer.string = "0"
        progressNumberLayer.fontSize = 16
        progressNumberLayer.alignmentMode = .center
        
        layer.addSublayer(progressNumberLayer)
    }
    
    private func setProgress(ratio progressRatio: Float, value progressValue: Int) {
        viewModel.status = .editing
        
        positiveProgressLayer.strokeEnd = 0
        
        if progressRatio > 0 {
            minusProgressLayer.strokeEnd = 0
            positiveProgressLayer.isHidden = false
            
            positiveProgressLayer.path = circlePath.cgPath
            positiveProgressColor = UIColor(displayP3Red: 247.0 / 255.0, green: 198.0 / 255.0, blue: 0, alpha: 1)
            progressBaseTrackColor = positiveTrackColorVlue
            positiveProgressLayer.strokeColor = positiveProgressColor.cgColor
            positiveProgressLayer.strokeEnd = abs(CGFloat(progressRatio))
            progressNumberLayer.foregroundColor = positiveProgressColor.cgColor
        } else {
            positiveProgressLayer.strokeEnd = 0
            minusProgressLayer.isHidden = false
            
            minusProgressColor = .white
            progressBaseTrackColor = minusTrackColorValue
            minusProgressLayer.strokeColor = minusProgressColor.cgColor
            minusProgressLayer.strokeEnd = abs(CGFloat(progressRatio))
            progressNumberLayer.foregroundColor = minusProgressColor.cgColor
        }
        
        progressBaseTrackLayer.strokeColor = progressBaseTrackColor.cgColor
        progressNumberLayer.string = "\(progressValue)"
    }
        
    private func change(to status: IndicatorStatus) {
        indicatorIconLayer.isHidden = false
        progressNumberLayer.isHidden = true
        progressBaseTrackLayer.strokeColor = progressBaseTrackColor.cgColor
        positiveProgressLayer.isHidden = true
        minusProgressLayer.isHidden = true
        
        switch status {
        case .initial:
            indicatorIconLayer.contents = normalIconImage
            progressBaseTrackLayer.strokeColor = UIColor.white.cgColor
        case .reset:
            indicatorIconLayer.contents = dimmedIconImage
            progressBaseTrackLayer.strokeColor = UIColor.gray.cgColor
        case .editing:
            indicatorIconLayer.contents = normalIconImage
            progressBaseTrackLayer.strokeColor = (progress > 0 ? positiveTrackColorVlue : minusTrackColorValue).cgColor
            indicatorIconLayer.isHidden = true
            progressNumberLayer.isHidden = false
            positiveProgressLayer.isHidden = false
            minusProgressLayer.isHidden = false
        case .deactive:
            indicatorIconLayer.contents = normalIconImage
            progressBaseTrackLayer.strokeColor = (progress > 0 ? positiveTrackColorVlue : minusTrackColorValue).cgColor
            indicatorIconLayer.isHidden = false
            progressNumberLayer.isHidden = true
            positiveProgressLayer.isHidden = false
            minusProgressLayer.isHidden = false
        }
    }
}

enum IndicatorStatus {
    case initial
    case reset
    case editing
    case deactive
}
