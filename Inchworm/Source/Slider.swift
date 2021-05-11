//
//  Slider.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

public protocol SliderDelegate {
    func didGetOffsetRatio(_ slider: Slider, activeIndicatorIndex: Int, offsetRatio: Float)
}

public class Slider: UIView {

    public var delegate: SliderDelegate?
    
    var indicatorContainer: ProcessIndicatorContainer!
    var slideRuler: SlideRuler!
    
    /** For easily rotating the slider when oriention is vertical
     
     - When orientation is horizontal, indicatorContainer is on the top, sliderRuler is on the bottom.
     - When orientation is vertical, indicatorContainer is on the left, sliderRuler is on the right.
    */
    var baseContainer = UIView()
    
    var config: Config! {
        didSet {
            handleConfigChange()
        }
    }
    
    // You can active different constraints for different orientation
    var containerHorizontalWidthConstraint: NSLayoutConstraint!
    var containerHoritontalHeightConstraint: NSLayoutConstraint!
    var containerVerticalWidthConstraint: NSLayoutConstraint!
    var containerVerticalHeightConstraint: NSLayoutConstraint!
    
    var observer: NSObjectProtocol?
        
    init(config: Config = Config(), frame: CGRect) {
        super.init(frame: frame)
        
        self.config = config
        
        observer = self.config.observe(\.orientation, options: .new) { [weak self] _, _ in
            self?.handleConfigChange()
        }
                        
        createIndicatorContainer()
        createSlideRuler()
        
        baseContainer.frame = bounds
        addSubview(baseContainer)
        baseContainer.addSubview(indicatorContainer)
        baseContainer.addSubview(slideRuler)
        
        initialAutolayoutConstraint()
        adjustContainerByOrientation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createIndicatorContainer() {
        indicatorContainer = ProcessIndicatorContainer(orientation: config.orientation, frame: CGRect(x: 0, y: 0, width: baseContainer.frame.width, height: config.indicatorSpan))
        
        indicatorContainer.didActive = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        
        indicatorContainer.didTempReset = { [weak self] in
            guard let self = self else { return }
            self.slideRuler.handleTempReset()
            
            let activeIndex = self.indicatorContainer.activeIndicatorIndex
            self.delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: 0)
        }
        
        indicatorContainer.didRemoveTempReset = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
    }
    
    func createSlideRuler() {
        slideRuler = SlideRuler(frame: CGRect(x: 0, y: baseContainer.frame.height / 2, width: baseContainer.frame.width, height: baseContainer.frame.height - config.slideRulerSpan))
        slideRuler.delegate = self
        slideRuler.forceAlignCenterFeedback = config.forceAlignCenterFeedback
    }
    
    func handleConfigChange() {
        adjustContainerByOrientation()
        indicatorContainer.orientation = config.orientation
        indicatorContainer.handleBoundsChange()
    }
    
    func initialAutolayoutConstraint() {
        baseContainer.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        slideRuler.translatesAutoresizingMaskIntoConstraints = false
        
        containerHorizontalWidthConstraint = baseContainer.widthAnchor.constraint(equalTo: widthAnchor)
        containerHoritontalHeightConstraint = baseContainer.heightAnchor.constraint(equalTo: heightAnchor)
        
        containerVerticalHeightConstraint = baseContainer.widthAnchor.constraint(equalTo: heightAnchor)
        containerVerticalWidthConstraint = baseContainer.heightAnchor.constraint(equalTo: widthAnchor)
        
        NSLayoutConstraint.activate([
            baseContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            baseContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
                        
            indicatorContainer.leadingAnchor.constraint(equalTo: baseContainer.leadingAnchor),
            indicatorContainer.trailingAnchor.constraint(equalTo: baseContainer.trailingAnchor),
            indicatorContainer.topAnchor.constraint(equalTo: baseContainer.topAnchor),
            indicatorContainer.heightAnchor.constraint(equalToConstant: config.indicatorSpan),
            
            slideRuler.leadingAnchor.constraint(equalTo: baseContainer.leadingAnchor),
            slideRuler.trailingAnchor.constraint(equalTo: baseContainer.trailingAnchor),
            slideRuler.topAnchor.constraint(equalTo: indicatorContainer.bottomAnchor, constant: config.spaceBetweenIndicatorAndSlideRule),
            slideRuler.heightAnchor.constraint(equalToConstant: config.slideRulerSpan)
        ])
    }
    
    // Deactivate first, then activate!
    func adjustContainerByOrientation() {
        if config.orientation == .horizontal {
            NSLayoutConstraint.deactivate([
                containerVerticalWidthConstraint,
                containerVerticalHeightConstraint
            ])
            
            NSLayoutConstraint.activate([
                containerHorizontalWidthConstraint,
                containerHoritontalHeightConstraint
            ])

            baseContainer.transform = .identity
        } else {
            NSLayoutConstraint.deactivate([
                containerHorizontalWidthConstraint,
                containerHoritontalHeightConstraint
            ])

            NSLayoutConstraint.activate([
                containerVerticalWidthConstraint,
                containerVerticalHeightConstraint
            ])
                        
            baseContainer.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        }
    }
    
    func addIndicatorWith(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        indicatorContainer.addIndicatorWith(limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0) {
        indicatorContainer.setActiveIndicatorIndex(index)
    }
    
    func setSlideRulerBy(progress: Float) {
        slideRuler.handleRemoveTempResetWith(progress: progress)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: progress)
    }
}

extension Slider: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.getActiveIndicator()?.progress = Float(offsetRatio)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, activeIndicatorIndex: activeIndex, offsetRatio: Float(offsetRatio))
    }
}
