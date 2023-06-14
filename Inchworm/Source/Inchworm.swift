//
//  Inchworm.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

public struct ProcessIndicatorModel {
    var limitNumber = 0
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
    
    public init(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
    }
}

/**
 You can set frame to CGRecte.zero if Autolayout is used
 */
public func createSlider(config: Config = Config(),
                            frame: CGRect,
                            processIndicatorModels: [ProcessIndicatorModel],
                            activeIndex: Int) -> Slider {
    let board: Slider = Slider(config: config, frame: frame)
                    
    processIndicatorModels.forEach {
        board.addIndicatorWith(limitNumber: $0.limitNumber, normalIconImage: $0.normalIconImage, dimmedIconImage: $0.dimmedIconImage)
    }
    
    board.setActiveIndicatorIndex(activeIndex)
    
    return board
}

public struct Config {
    public var orientation: SliderOrientation = .horizontal    
    public var indicatorSpan: CGFloat = 50
    public var slideRulerSpan: CGFloat = 50
    public var spaceBetweenIndicatorAndSlideRule: CGFloat = 10
    public var forceAlignCenterFeedback = true
    public var sliderValueRangeType: SliderValueRangeType = .bilateral
    
    public init() {
        
    }
}

public enum SliderOrientation: Int {
    case horizontal
    case vertical
}

public enum SliderValueRangeType {
    case bilateral
    case unilateral
}
