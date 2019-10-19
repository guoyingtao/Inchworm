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
    var activeIndicatorIndex = 0
    let span: CGFloat = 20
    var pageWidth: CGFloat = 0
    var iconLength: CGFloat = 0
    
    var didActive: (Float) -> Void = { _ in }
    var didTempReset = {}
    var didRemoveTempReset: (Float) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconLength = min(frame.width, frame.height)
        pageWidth = iconLength + span
        
        backgroundSlideView.frame = bounds
        backgroundSlideView.showsVerticalScrollIndicator = false
        backgroundSlideView.showsHorizontalScrollIndicator = false
        backgroundSlideView.delegate = self
        addSubview(backgroundSlideView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addIconWith(limitNumber: Int, normalIconImage: CGImage, dimmedIconImage: CGImage) {
        let progressView = ProcessIndicatorView(frame: CGRect(x: 0, y: 0, width: iconLength, height: iconLength), limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
        progressView.delegate = self
        progressView.index = progressViewList.count
        
        progressViewList.append(progressView)
        backgroundSlideView.addSubview(progressView)
        
        // iF you want a cumtomized page width, comment this one
        // backgroundSlideView.isPagingEnabled = true
        
        let slideContentSize = getSlideContentSize(byIndicatorLength: progressView.frame.width)
        backgroundSlideView.contentSize = CGSize(width: backgroundSlideView.frame.width + slideContentSize.width - progressView.frame.width, height: backgroundSlideView.frame.height)
                
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
    
    func setActiveIndicatorIndex(_ index: Int = 0, animated: Bool = false) {
        if index < 0 {
            activeIndicatorIndex = 0
        } else if index > progressViewList.count - 1 {
            activeIndicatorIndex = progressViewList.count - 1
        } else {
            activeIndicatorIndex = index
        }
        
        guard let indicator = getActiveIndicator() else {
            return
        }
        
        indicator.active = true
        
        let slideContentSize = getSlideContentSize(byIndicatorLength: iconLength)
        let currentPositon = indicator.center
        let targetPosition = CGPoint(x: (backgroundSlideView.contentSize.width - slideContentSize.width) / 2 + iconLength / 2, y: 0)
        
        let offset = CGPoint(x: currentPositon.x - targetPosition.x, y: 0)
        backgroundSlideView.setContentOffset(offset, animated: animated)
    }
    
    func getActiveIndicator() -> ProcessIndicatorView? {
        guard 0..<progressViewList.count ~= activeIndicatorIndex else {
            return nil
        }
    
        return progressViewList[activeIndicatorIndex]
    }
}

extension IndicatorContainer: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let kMaxIndex = progressViewList.count

        let targetX = scrollView.contentOffset.x + velocity.x * 60.0
        var targetIndex = 0
        
        if (velocity.x > 0) {
            targetIndex = Int(ceil(targetX / pageWidth))
        } else if (velocity.x == 0) {
            targetIndex = Int(round(targetX / pageWidth))
        } else if (velocity.x < 0) {
            targetIndex = Int(floor(targetX / pageWidth))
        }

        if (targetIndex < 0) {
            targetIndex = 0
        }

        if (targetIndex > kMaxIndex) {
            targetIndex = kMaxIndex
        }

        targetContentOffset.pointee.x = CGFloat(targetIndex) * pageWidth;
        setActiveIndicatorIndex(targetIndex)
    }
}

extension IndicatorContainer: ProcessIndicatorViewDelegate {
    func didActive(_ processIndicatorView: ProcessIndicatorView) {
        setActiveIndicatorIndex(processIndicatorView.index, animated: true)
        
        guard processIndicatorView.status == .changed else { return }        
        self.didActive(processIndicatorView.progress)
    }
    
    func didTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didTempReset()
    }
    
    func didRemoveTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didRemoveTempReset(processIndicatorView.progress)
    }
}
