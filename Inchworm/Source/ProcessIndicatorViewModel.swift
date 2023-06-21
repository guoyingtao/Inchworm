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
    
    var status: IndicatorStatus = .initial {
        didSet {
            didSetStatus(status)
        }
    }
    
    var didSetStatus: (_ status: IndicatorStatus) -> Void = { _ in }
    
    var isActive = false
    
    init(sliderValueRangeType: SliderValueRangeType) {
        self.sliderValueRangeType = sliderValueRangeType
    }
    
    private func setDefaultProgress() {
        switch sliderValueRangeType {
        case .unilateral(let limit, let defaultValue):
            fallthrough
        case .bilateral(let limit, let defaultValue):
            progress = Float(defaultValue) / Float(limit)
        }
    }
    
    private func setInitialStatus() {
        if progress == 0 {
            status = .initial
        } else {
            status = .deactive
        }
    }
    
    func initialize() {
        setDefaultProgress()
        setInitialStatus()
    }
    
    func deactive() {
        isActive = false
        
        if status != .reset {
            if progress == 0 {
                status = .initial
            } else {
                status = .deactive
            }
        }
    }
}
