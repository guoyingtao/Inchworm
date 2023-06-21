//
//  ProcessIndicatorViewModel.swift
//  Inchworm
//
//  Created by Yingtao Guo on 6/21/23.
//

import Foundation

class ProcessIndicatorViewModel {
    var sliderValueRangeType: SliderValueRangeType
    
    var progress: Float = 0 {
        didSet {
            let progressValue: Int
            switch sliderValueRangeType {
            case .bilateral(let limit, _):
                fallthrough
            case .unilateral(let limit, _):
                progressValue = Int(progress * Float(limit))
            }
            didSetProgress(progressValue)
        }
    }
    
    var didSetProgress: (_ progressValue: Int) -> Void = { _ in }
    
    init(sliderValueRangeType: SliderValueRangeType) {
        self.sliderValueRangeType = sliderValueRangeType
    }
    
    func setDefaultProgress() {
        switch sliderValueRangeType {
        case .unilateral(let limit, let defaultValue):
            fallthrough
        case .bilateral(let limit, let defaultValue):
            progress = Float(defaultValue) / Float(limit)
        }
    }
}
