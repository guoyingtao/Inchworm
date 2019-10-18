//
//  IndicatorContainer.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class IndicatorContainer: UIView {

    var progressViewList: [ProcessIndicatorView] = []
    var backgroundSlideView = UIScrollView()
    var activeIndicator: ProcessIndicatorView?
    let span: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundSlideView.frame = bounds
        backgroundSlideView.backgroundColor = .gray
        addSubview(backgroundSlideView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addIconWith(iconImage: CGImage, andLimitNumber limitNumber: Int) {
        let length = min(frame.width, frame.height)
        let progressView = ProcessIndicatorView(frame: CGRect(x: 0, y: 0, width: length, height: length), limitNumber: limitNumber, iconImage: iconImage)
        
        progressViewList.append(progressView)
        backgroundSlideView.addSubview(progressView)
        
        let slideContentSize = getSlideContentSize(byIndicatorLength: progressView.frame.width)
        backgroundSlideView.contentSize = CGSize(width: backgroundSlideView.frame.width + slideContentSize.width - progressView.frame.width, height: backgroundSlideView.frame.height)
        backgroundSlideView.contentOffset = CGPoint(x: slideContentSize.width / 2 - progressView.frame.width / 2, y: 0)
        
        let startX = backgroundSlideView.contentSize.width / 2 - slideContentSize.width / 2
        for i in 0..<progressViewList.count {
            let progressView = progressViewList[i]
            progressView.center = CGPoint(x: startX + CGFloat(i) * (progressView.frame.width + span) + progressView.frame.width / 2, y: backgroundSlideView.frame.height / 2)
        }
    }
    
    func getSlideContentSize(byIndicatorLength indicatorLength: CGFloat) -> CGSize {
        guard progressViewList.count > 0 else {
            return backgroundSlideView.contentSize
        }
        
        let width: CGFloat = (indicatorLength * CGFloat(progressViewList.count)) + span * CGFloat(progressViewList.count - 1)
        let height = backgroundSlideView.contentSize.height
        return CGSize(width: width, height: height)
    }
    
    func setActiveIndicator() {
        activeIndicator = progressViewList.first!
    }
}
