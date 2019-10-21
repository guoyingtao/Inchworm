//
//  ProcessIndicatorContainer.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class ProcessIndicatorContainer: UIView {

    var progressIndicatorViewList: [ProcessIndicatorView] = []
    var backgroundSlideView = UIScrollView()
    var activeIndicatorIndex = 0
    let span: CGFloat = 20
    var pageWidth: CGFloat = 0
    var iconLength: CGFloat = 0
    
    var didActive: (Float) -> Void = { _ in }
    var didTempReset = {}
    var didRemoveTempReset: (Float) -> Void = { _ in }
    
    var orientation: SliderOrientation = .horizontal
    
    override var bounds: CGRect {
        didSet {
            handleBoundsChange()
        }
    }
    
    init(orientation: SliderOrientation = .horizontal, frame: CGRect) {
        super.init(frame: frame)
        self.orientation = orientation
        
        backgroundSlideView.showsVerticalScrollIndicator = false
        backgroundSlideView.showsHorizontalScrollIndicator = false
        backgroundSlideView.delegate = self
        addSubview(backgroundSlideView)
        
        // iF you want a customized page width, comment this one
        // backgroundSlideView.isPagingEnabled = true
        
        setupUIFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func handleBoundsChange() {
        setupUIFrames()
        
        progressIndicatorViewList.forEach { [weak self] in
            $0.frame = CGRect(x: 0, y: 0, width: iconLength, height: iconLength)
            self?.setOrientations(for: $0)
        }
        
        rerangeIndicators()
        setActiveIndicatorIndex(activeIndicatorIndex)
    }
    
    func setupUIFrames() {
        iconLength = min(frame.width, frame.height)
        pageWidth = iconLength + span
        
        backgroundSlideView.frame = bounds
    }
    
    func rerangeIndicators() {
        let slideContentSize = getSlideContentSize()
        backgroundSlideView.contentSize = CGSize(width: backgroundSlideView.frame.width + slideContentSize.width - iconLength, height: backgroundSlideView.frame.height)
                
        let startX = backgroundSlideView.contentSize.width / 2 - slideContentSize.width / 2
        for i in 0..<progressIndicatorViewList.count {
            let progressView = progressIndicatorViewList[i]
            progressView.center = CGPoint(x: startX + CGFloat(i) * (progressView.frame.width + span) + progressView.frame.width / 2, y: backgroundSlideView.frame.height / 2)
        }
    }
    
    func addIndicatorWith(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        let indicatorView = ProcessIndicatorView(frame: CGRect(x: 0, y: 0, width: iconLength, height: iconLength), limitNumber: limitNumber, normalIconImage: normalIconImage, dimmedIconImage: dimmedIconImage)
        indicatorView.delegate = self
        indicatorView.index = progressIndicatorViewList.count
        
        progressIndicatorViewList.append(indicatorView)
        backgroundSlideView.addSubview(indicatorView)
                                
        setOrientations(for: indicatorView)
        rerangeIndicators()
    }
    
    func setOrientations(for indicatorView: ProcessIndicatorView) {
        if orientation == .horizontal {
            indicatorView.transform = CGAffineTransform(rotationAngle: 0)
        } else {
            indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
    }
    
    func getSlideContentSize() -> CGSize {
        guard progressIndicatorViewList.count > 0 else {
            return backgroundSlideView.contentSize
        }
        
        let width = progressIndicatorViewList.map{ $0.frame.width }.reduce(0, +) + span * CGFloat(progressIndicatorViewList.count - 1)
        let height = backgroundSlideView.contentSize.height
        
        return CGSize(width: width, height: height)
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0, animated: Bool = false) {
        if index < 0 {
            activeIndicatorIndex = 0
        } else if index > progressIndicatorViewList.count - 1 {
            activeIndicatorIndex = progressIndicatorViewList.count - 1
        } else {
            activeIndicatorIndex = index
        }
        
        guard let indicator = getActiveIndicator() else {
            return
        }
        
        indicator.active = true
        
        let slideContentSize = getSlideContentSize()
        let currentPositon = indicator.center
        let targetPosition = CGPoint(x: (backgroundSlideView.contentSize.width - slideContentSize.width) / 2 + iconLength / 2, y: 0)
        
        let offset = CGPoint(x: currentPositon.x - targetPosition.x, y: 0)
        backgroundSlideView.setContentOffset(offset, animated: animated)
    }
    
    func getActiveIndicator() -> ProcessIndicatorView? {
        guard 0..<progressIndicatorViewList.count ~= activeIndicatorIndex else {
            return nil
        }
    
        return progressIndicatorViewList[activeIndicatorIndex]
    }
}

extension ProcessIndicatorContainer: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let kMaxIndex = progressIndicatorViewList.count

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
        
        guard let processIndicatorView = getActiveIndicator() else { return }
        if processIndicatorView.status == .editing {
            self.didActive(processIndicatorView.progress)
        }
    }
}

extension ProcessIndicatorContainer: ProcessIndicatorViewDelegate {
    func didActive(_ processIndicatorView: ProcessIndicatorView) {
        setActiveIndicatorIndex(processIndicatorView.index, animated: true)        
        self.didActive(processIndicatorView.progress)
    }
    
    func didTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didTempReset()
    }
    
    func didRemoveTempReset(_ processIndicatorView: ProcessIndicatorView) {
        self.didRemoveTempReset(processIndicatorView.progress)
    }
}
