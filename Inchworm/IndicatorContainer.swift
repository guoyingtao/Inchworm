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
    var pageWidth: CGFloat = 70
    var offset: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundSlideView.frame = bounds
        backgroundSlideView.delegate = self
        addSubview(backgroundSlideView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addIconWith(limitNumber: Int, normalIconImage: CGImage, dimmedIconImage: CGImage) {
        let length = min(frame.width, frame.height)
        let progressView = ProcessIndicatorView(frame: CGRect(x: 0, y: 0, width: length, height: length), limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
        
        progressViewList.append(progressView)
        backgroundSlideView.addSubview(progressView)
        
        // iF you want a cumtomized page width, comment this one
//        backgroundSlideView.isPagingEnabled = true
        
        let slideContentSize = getSlideContentSize(byIndicatorLength: progressView.frame.width)
        backgroundSlideView.contentSize = CGSize(width: backgroundSlideView.frame.width + slideContentSize.width - progressView.frame.width, height: backgroundSlideView.frame.height)
        
        offset = CGPoint(x: slideContentSize.width / 2 - progressView.frame.width / 2, y: 0)
        backgroundSlideView.contentOffset = offset
        
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

extension IndicatorContainer: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let kMaxIndex: CGFloat = 2

        let targetX = scrollView.contentOffset.x + velocity.x * 60.0
        var targetIndex: CGFloat = 0.0
        if (velocity.x > 0) {
            targetIndex = ceil(targetX / pageWidth)
        } else if (velocity.x == 0) {
            targetIndex = round(targetX / pageWidth)
        } else if (velocity.x < 0) {
            targetIndex = floor(targetX / pageWidth)
        }

        if (targetIndex < 0) {
            targetIndex = 0
        }

        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }

        targetContentOffset.pointee.x = targetIndex * pageWidth;
    }
}
