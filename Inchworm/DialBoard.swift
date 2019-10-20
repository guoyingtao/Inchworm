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
    
    init(config: Config = Config(), frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        indicatorContainer = IndicatorContainer(orientation: config.orientation, frame: CGRect(x: 0, y: 0, width: frame.width, height: config.indicatorSpan))
        slideRuler = SlideRuler(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: frame.height - config.slideRulerSpan))
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
        
        addSubview(indicatorContainer)
        addSubview(slideRuler)
        
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        slideRuler.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorContainer.topAnchor.constraint(equalTo: topAnchor),
            indicatorContainer.heightAnchor.constraint(equalToConstant: config.indicatorSpan),
            
            slideRuler.leadingAnchor.constraint(equalTo: leadingAnchor),
            slideRuler.trailingAnchor.constraint(equalTo: trailingAnchor),
            slideRuler.topAnchor.constraint(equalTo: indicatorContainer.bottomAnchor, constant: config.spaceBetweenIndicatorAndSlideRule),
            slideRuler.heightAnchor.constraint(equalToConstant: config.slideRulerSpan)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
