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
        
        indicatorContainer = IndicatorContainer(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2))
        slideRuler = SlideRuler(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: frame.height / 2))
        slideRuler.delegate = self
        
        addSubview(indicatorContainer)
        addSubview(slideRuler)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension DialContainer: SlideRulerDelegate {
    func didGetOffsetRatio(from slideRuler: SlideRuler, offsetRatio: CGFloat) {
        indicatorContainer.activeIndicator.setProgress(Float(offsetRatio))
    }
}
