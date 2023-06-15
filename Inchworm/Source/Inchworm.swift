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
    var sliderValueRangeType: SliderValueRangeType = .bilateral
    
    public init(valueRange: ClosedRange<Int>, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        guard abs(valueRange.lowerBound) == abs(valueRange.upperBound) || valueRange.lowerBound == 0 else {
            fatalError("InchWorm only supports ranges like [0, 100] or [-100, 100]")
        }
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
        self.limitNumber = valueRange.upperBound
        
        if abs(valueRange.lowerBound) == abs(valueRange.upperBound) {
            sliderValueRangeType = .bilateral
        } else {
            sliderValueRangeType = .unilateral
        }
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

public enum SliderOrientation: Int {
    case horizontal
    case vertical
}

public enum SliderValueRangeType {
    case bilateral
    case unilateral
}
