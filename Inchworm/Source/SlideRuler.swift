//
//  SlideRuler.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

fileprivate let scaleBarNumber = 41
fileprivate let majorScaleBarNumber = 5
fileprivate let scaleWidth: CGFloat = 1
fileprivate let pointerWidth: CGFloat = 1

protocol SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat)
}

class SlideRuler: UIView {
    var forceAlignCenterFeedback = true
    let pointer = CALayer()
    let centralDot = CAShapeLayer()
    let scrollRulerView = UIScrollView()
    let dotWidth: CGFloat = 6
    var sliderOffsetRatio: CGFloat = 0.5
    var positionInfoProvider: SliderRulerPositionInfoProvider
    
    let scaleBarLayer: CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = scaleBarNumber
        return r
    } ()
    
    let majorScaleBarLayer: CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = majorScaleBarNumber
        return r
    } ()
    
    var delegate: SlideRulerDelegate?
    var reset = false
    var offsetValue: CGFloat = 0
    
    override var bounds: CGRect {
        didSet {
            setUIFrames()
        }
    }
    
    init(frame: CGRect, sliderValueRangeType: SliderValueRangeType) {
        switch sliderValueRangeType {
        case .bilateral:
            self.positionInfoProvider = BilateralTypeSliderRulerPositionInfoProvider()
        case .unilateral:
            self.positionInfoProvider = UnilateralTypeSliderRulerPositionInfoProvider()
        }

        super.init(frame: frame)
        self.positionInfoProvider.slideRuler = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        sliderOffsetRatio = positionInfoProvider.getInitialOffsetRatio()
        
        setupSlider()
        makeRuler()
        makeCentralDot()
        makePointer()
        
        setUIFrames()
    }
    
    @objc func setSliderDelegate() {
        scrollRulerView.delegate = self
    }
    
    public func setUIFrames() {
        scrollRulerView.frame = bounds

        offsetValue = sliderOffsetRatio * scrollRulerView.frame.width
        scrollRulerView.delegate = nil
        scrollRulerView.contentSize = CGSize(width: frame.width * 2, height: frame.height)
        scrollRulerView.contentOffset = CGPoint(x: offsetValue, y: 0)
        
        perform(#selector(setSliderDelegate), with: nil, afterDelay: 0.1)
        // slider.delegate = self

        pointer.frame = CGRect(x: (frame.width / 2 - pointerWidth / 2), y: bounds.origin.y, width: pointerWidth, height: frame.height)
        
        let centralDotOriginX = positionInfoProvider.getCentralDotOriginX()
        centralDot.frame = CGRect(x: centralDotOriginX, y: frame.height * 0.2, width: dotWidth, height: dotWidth)
        
        centralDot.path = UIBezierPath(ovalIn: centralDot.bounds).cgPath
        
        scaleBarLayer.frame = CGRect(x: frame.width / 2, y: 0.6 * frame.height, width: frame.width, height: 0.4 * frame.height)
        scaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((scaleBarNumber - 1)) , 0, 0)

        scaleBarLayer.sublayers?.forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 1, height: scaleBarLayer.frame.height)
        }
        
        majorScaleBarLayer.frame = scaleBarLayer.frame
        majorScaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((majorScaleBarNumber - 1)) , 0, 0)
        
        majorScaleBarLayer.sublayers?.forEach {
            $0.frame = CGRect(x: 0, y: 0, width: 1, height: majorScaleBarLayer.frame.height)
        }
    }
    
    private func setupSlider() {
        addSubview(scrollRulerView)
        
        scrollRulerView.showsHorizontalScrollIndicator = false
        scrollRulerView.showsVerticalScrollIndicator = false
        scrollRulerView.delegate = self
    }
    
    private func makePointer() {
        pointer.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(pointer)
    }
    
    private func makeCentralDot() {
        centralDot.fillColor = UIColor.white.cgColor
        scrollRulerView.layer.addSublayer(centralDot)
    }
    
    private func makeRuler() {
        scaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let scaleBar = makeBarScaleMark(byColor: UIColor.gray.cgColor)
        scaleBarLayer.addSublayer(scaleBar)
        
        scrollRulerView.layer.addSublayer(scaleBarLayer)
        
        majorScaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let majorScaleBar = makeBarScaleMark(byColor: UIColor.white.cgColor)
        majorScaleBarLayer.addSublayer(majorScaleBar)
        
        scrollRulerView.layer.addSublayer(majorScaleBarLayer)
    }
    
    private func makeBarScaleMark(byColor color: CGColor) -> CALayer {
        let bar = CALayer()
        bar.backgroundColor = color
        
        return bar
    }
    
    func handleTempReset() {
        let offset = CGPoint(x: offsetValue, y: 0)
        scrollRulerView.delegate = nil
        scrollRulerView.setContentOffset(offset, animated: false)
        scrollRulerView.delegate = self
        
        centralDot.isHidden = true
        let color = UIColor.gray.cgColor
        scaleBarLayer.sublayers?.forEach { $0.backgroundColor = color}
        majorScaleBarLayer.sublayers?.forEach { $0.backgroundColor = color}
    }
    
    func handleRemoveTempResetWith(progress: Float) {
        centralDot.fillColor = UIColor.white.cgColor
        
        scaleBarLayer.sublayers?.forEach { $0.backgroundColor = UIColor.gray.cgColor}
        majorScaleBarLayer.sublayers?.forEach { $0.backgroundColor = UIColor.white.cgColor}
        
        scrollRulerView.delegate = nil
        
        let offsetX = positionInfoProvider.getRulerOffsetX(with: CGFloat(progress))
        let offset = CGPoint(x: offsetX, y: 0)
        scrollRulerView.setContentOffset(offset, animated: false)
        scrollRulerView.delegate = self
        
        checkCentralDotHiddenStatus()
    }
    
    func checkCentralDotHiddenStatus() {
        centralDot.isHidden = (scrollRulerView.contentOffset.x == frame.width / 2)
    }
}

extension SlideRuler: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkCentralDotHiddenStatus()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centralDot.isHidden = false
        
        let speed = scrollView.panGestureRecognizer.velocity(in: scrollView.superview)
        
        let limit = frame.width / CGFloat((scaleBarNumber - 1) * 2)
        
        func checkIsCenterPosition() -> Bool {
            return positionInfoProvider.checkIsCenterPosition(with: limit)
        }        
        
        if checkIsCenterPosition() && abs(speed.x) < 10.0 {
            
            if !reset {
                reset = true
                
                if forceAlignCenterFeedback {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
                
                func forceAlignCenter() {
                    let offset = CGPoint(x: positionInfoProvider.getForceAlignCenterX(), y: 0)
                    scrollView.setContentOffset(offset, animated: false)
                    delegate?.didGetOffsetRatio(from: self, offsetRatio: 0)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    forceAlignCenter()
                }
                
                forceAlignCenter()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                    usleep(1000000)
                }
            }
        } else {
            reset = false
        }
        
        let offsetRatio = positionInfoProvider.getOffsetRatio()
        delegate?.didGetOffsetRatio(from: self, offsetRatio: offsetRatio)
        
        positionInfoProvider.handleOffsetRatioWhenScrolling(scrollView)
    }
}
