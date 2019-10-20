//
//  DialBoard.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

public protocol DialBoardDelegate {
    func didGetOffsetRatio(_ board: DialBoard, indicatorIndex: Int, offsetRatio: Float)
}

public class DialBoard: UIView {

    var indicatorContainer: IndicatorContainer!
    var slideRuler: SlideRuler!
    var delegate: DialBoardDelegate?
    var container = UIView()
    var config: Config! {
        didSet {
            if oldValue.orientation != config.orientation {
                setContainerConstraint()
            }            
        }
    }
    
    var containerHorizontalWidthConstraint: NSLayoutConstraint!
    var containerHoritontalHeightConstraint: NSLayoutConstraint!
    var containerVerticalWidthConstraint: NSLayoutConstraint!
    var containerVerticalHeightConstraint: NSLayoutConstraint!
    
    var observer: NSObjectProtocol?
        
    init(config: Config = Config(), frame: CGRect) {
        super.init(frame: frame)
        self.config = config
        
        observer = self.config.observe(\.orientation, options: .new) { [weak self] config, change in
            self?.setContainerConstraint()
        }
        
        container.frame = bounds
        container.frame = bounds
        addSubview(container)
        
        indicatorContainer = IndicatorContainer(orientation: config.orientation, frame: CGRect(x: 0, y: 0, width: container.frame.width, height: config.indicatorSpan))
        slideRuler = SlideRuler(frame: CGRect(x: 0, y: container.frame.height / 2, width: container.frame.width, height: container.frame.height - config.slideRulerSpan))
        slideRuler.delegate = self
        
        indicatorContainer.didActive = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        
        indicatorContainer.didTempReset = { [weak self] in
            guard let self = self else { return }
            self.slideRuler.handleTempReset()
            
            let activeIndex = self.indicatorContainer.activeIndicatorIndex
            self.delegate?.didGetOffsetRatio(self, indicatorIndex: activeIndex, offsetRatio: 0)
        }
        
        indicatorContainer.didRemoveTempReset = { [weak self] progress in
            self?.setSlideRulerBy(progress: progress)
        }
        
        container.addSubview(indicatorContainer)
        container.addSubview(slideRuler)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        slideRuler.translatesAutoresizingMaskIntoConstraints = false
        
        containerHorizontalWidthConstraint = container.widthAnchor.constraint(equalTo: widthAnchor)
        containerHoritontalHeightConstraint = container.heightAnchor.constraint(equalTo: heightAnchor)
        
        containerVerticalHeightConstraint = container.widthAnchor.constraint(equalTo: heightAnchor)
        containerVerticalWidthConstraint = container.heightAnchor.constraint(equalTo: widthAnchor)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
                        
            indicatorContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            indicatorContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            indicatorContainer.topAnchor.constraint(equalTo: container.topAnchor),
            indicatorContainer.heightAnchor.constraint(equalToConstant: config.indicatorSpan),
            
            slideRuler.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            slideRuler.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            slideRuler.topAnchor.constraint(equalTo: indicatorContainer.bottomAnchor, constant: config.spaceBetweenIndicatorAndSlideRule),
            slideRuler.heightAnchor.constraint(equalToConstant: config.slideRulerSpan)
        ])
        
        setContainerConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setContainerConstraint() {
        if config.orientation == .horizontal {
            containerHorizontalWidthConstraint.isActive = true
            containerHoritontalHeightConstraint.isActive = true
            containerVerticalWidthConstraint.isActive = false
            containerVerticalHeightConstraint.isActive = false
        } else {
            containerHorizontalWidthConstraint.isActive = false
            containerHoritontalHeightConstraint.isActive = false
            containerVerticalWidthConstraint.isActive = true
            containerVerticalHeightConstraint.isActive = true
            
            container.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        }
    }
    
    func addIconWith(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        indicatorContainer.addIconWith(limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0) {
        indicatorContainer.setActiveIndicatorIndex(index)
    }
    
    func setSlideRulerBy(progress: Float) {
        slideRuler.handleRemoveTempResetWith(progress: progress)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, indicatorIndex: activeIndex, offsetRatio: progress)
    }
}

extension DialBoard: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.getActiveIndicator()?.progress = Float(offsetRatio)
        
        let activeIndex = indicatorContainer.activeIndicatorIndex
        delegate?.didGetOffsetRatio(self, indicatorIndex: activeIndex, offsetRatio: Float(offsetRatio))
    }
}
