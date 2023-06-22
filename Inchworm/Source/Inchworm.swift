//
//  Inchworm.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

public struct ProcessIndicatorModel {
    var normalIconImage: CGImage
    var dimmedIconImage: CGImage
    var sliderValueRangeType: SliderValueRangeType
    
    public init(sliderValueRangeType: SliderValueRangeType, normalIconImage: CGImage, dimmedIconImage: CGImage) {
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
        self.sliderValueRangeType = sliderValueRangeType
    }
}

/**
 You can set frame to CGRecte.zero if Autolayout is used
 */
public func createSlider(config: Config = Config(),
                         frame: CGRect,
                         processIndicatorModels: [ProcessIndicatorModel],
                         activeIndex: Int) -> Slider {
    return Slider(config: config,
                  frame: frame,
                  processIndicatorModels: processIndicatorModels,
                  activeIndex: activeIndex)
}

public struct Config {
    public var orientation: SliderOrientation = .horizontal
    public var indicatorSpan: CGFloat = 50
    public var slideRulerSpan: CGFloat = 50
    public var spaceBetweenIndicatorAndSlideRule: CGFloat = 10
    public var forceAlignCenterFeedback = true
    
    public init() {}
}

public enum SliderOrientation {
    case horizontal
    case vertical
}

public enum SliderValueRangeType {
    case bilateral(limit: Int, defaultValue: Int = 0)
    case unilateral(limit: Int, defaultValue: Int = 0)
}
