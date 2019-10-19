//
//  DialContainer.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class DialContainer: UIView {

    var indicatorContainer: IndicatorContainer!
    var slideRuler: SlideRuler!    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        indicatorContainer = IndicatorContainer(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2))
        slideRuler = SlideRuler(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: frame.height / 2))
        slideRuler.delegate = self
        
        indicatorContainer.didActive = { [weak self] progress in
            self?.slideRuler.handleRemoveTempResetWith(progress: progress)
        }
        
        indicatorContainer.didTempReset = { [weak self] in
            self?.slideRuler.handleTempReset()
        }
        
        indicatorContainer.didRemoveTempReset = { [weak self] progress in
            self?.slideRuler.handleRemoveTempResetWith(progress: progress)
        }
        
        addSubview(indicatorContainer)
        addSubview(slideRuler)
        
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        slideRuler.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicatorContainer.topAnchor.constraint(equalTo: topAnchor),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 50),
            indicatorContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            slideRuler.topAnchor.constraint(equalTo:  indicatorContainer.bottomAnchor),
            slideRuler.bottomAnchor.constraint(equalTo:  bottomAnchor),
            slideRuler.leadingAnchor.constraint(equalTo:  leadingAnchor),
            slideRuler.trailingAnchor.constraint(equalTo:  trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addIconWith(limitNumber: Int, normalIconImage: CGImage, dimmedIconImage: CGImage) {
        indicatorContainer.addIconWith(limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0) {
        indicatorContainer.setActiveIndicatorIndex(index)
    }    
}

extension DialContainer: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.getActiveIndicator()?.progress = Float(offsetRatio)
    }
}
