//
//  SlideRuler.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

let scaleBarNumber = 41
let majorScaleBarNumber = 5
let scaleWidth: CGFloat = 1

protocol SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: Double)
}

class SlideRuler: UIView {
    
    let pointer = CAShapeLayer()
    let centralDot = CAShapeLayer()
    let slider = UIScrollView()
    
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
    
    var offsetDelegate: SlideRulerDelegate?
    var reset = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        setupSlider()
        makeRuler()
        makeCentralDot()
        makePointer()
    }
    
    private func setupSlider() {
        slider.frame = bounds
        addSubview(slider)
        
        slider.contentSize = CGSize(width: frame.width * 2, height: frame.height)
        slider.contentOffset = CGPoint(x: frame.width / 2, y: 0)
        slider.showsHorizontalScrollIndicator = false
        slider.showsVerticalScrollIndicator = false
        slider.delegate = self
    }
    
    private func makePointer() {
        let pointer = CALayer()
        pointer.backgroundColor = UIColor.white.cgColor
        let pointerWidth: CGFloat = 1
        pointer.frame = CGRect(x: (frame.width / 2 - pointerWidth / 2), y: 0, width: pointerWidth, height: frame.height)
        layer.addSublayer(pointer)
    }
    
    private func makeCentralDot() {
        let dotWidth: CGFloat = 6
        centralDot.frame = CGRect(x: frame.width - dotWidth / 2, y: frame.height * 0.2, width: dotWidth, height: dotWidth)
        centralDot.path = UIBezierPath(ovalIn: centralDot.bounds).cgPath
        centralDot.fillColor = UIColor.white.cgColor
        
        slider.layer.addSublayer(centralDot)
    }
    
    private func makeRuler() {
        scaleBarLayer.frame = CGRect(x: frame.width / 2, y: 0.6 * frame.height, width: frame.width, height: 0.4 * frame.height)
        scaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((scaleBarNumber - 1)) , 0, 0)

        scaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let scaleBar = makeBarScaleMark(byHeight: scaleBarLayer.frame.height, andColor: UIColor.gray.cgColor)
        scaleBarLayer.addSublayer(scaleBar)
        
        slider.layer.addSublayer(scaleBarLayer)
        
        majorScaleBarLayer.frame = scaleBarLayer.frame
        majorScaleBarLayer.instanceTransform = CATransform3DMakeTranslation((frame.width - scaleWidth) / CGFloat((majorScaleBarNumber - 1)) , 0, 0)
        majorScaleBarLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let majorScaleBar = makeBarScaleMark(byHeight: scaleBarLayer.frame.height, andColor: UIColor.white.cgColor)
        majorScaleBarLayer.addSublayer(majorScaleBar)
        
        slider.layer.addSublayer(majorScaleBarLayer)
    }
    
    private func makeBarScaleMark(byHeight height: CGFloat, andColor color: CGColor) -> CALayer {
        let bar = CALayer()
        bar.frame = CGRect(x: 0, y: 0, width: 1, height: height)
        bar.backgroundColor = color
        
        return bar
    }
}

extension SlideRuler: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        centralDot.isHidden = (slider.contentOffset.x == frame.width / 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centralDot.isHidden = false
        
        let speed = scrollView.panGestureRecognizer.velocity(in: scrollView.superview)
        
        let limit = frame.width / CGFloat((scaleBarNumber - 1) * 2)
        if abs(slider.contentOffset.x - frame.width / 2) < limit && abs(speed.x) < 10.0 {
            if !reset {
                reset = true
                let offset = CGPoint(x: frame.width / 2, y: 0)
                scrollView.setContentOffset(offset, animated: false)
            }
        } else {
            reset = false
        }
    }
}
