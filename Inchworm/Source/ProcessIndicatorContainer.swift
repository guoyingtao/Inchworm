//
//  ProcessIndicatorContainer.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class ProcessIndicatorContainer: UIView {
    var processIndicatorViewList: [ProcessIndicatorView] = []
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
                
        setupUIFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func handleBoundsChange() {
        setupUIFrames()
        
        processIndicatorViewList.forEach { [weak self] in
            $0.frame = CGRect(x: 0, y: 0, width: iconLength, height: iconLength)
            self?.setOrientations(for: $0)
        }
        
        reRangeIndicators()
        setActiveIndicatorIndex(activeIndicatorIndex)
    }
    
    func setupUIFrames() {
        iconLength = min(frame.width, frame.height)
        pageWidth = iconLength + span
        
        backgroundSlideView.frame = bounds
    }
    
    func reRangeIndicators() {
        let slideContentSize = getSlideContentSize()
        backgroundSlideView.contentSize = CGSize(width: backgroundSlideView.frame.width + slideContentSize.width - iconLength, height: backgroundSlideView.frame.height)
                
        let startX = backgroundSlideView.contentSize.width / 2 - slideContentSize.width / 2
        for i in 0..<processIndicatorViewList.count {
            let progressView = processIndicatorViewList[i]
            progressView.center = CGPoint(x: startX + CGFloat(i) * (progressView.frame.width + span) + progressView.frame.width / 2, y: backgroundSlideView.frame.height / 2)
        }
    }
    
    func addIndicatorWith(sliderValueRangeType: SliderValueRangeType,
                          normalIconImage: CGImage?,
                          dimmedIconImage: CGImage?) {
        let indicatorFrame = CGRect(x: 0, y: 0, width: iconLength, height: iconLength)
        let viewModel = ProcessIndicatorViewModel(sliderValueRangeType: sliderValueRangeType)
        let indicatorView = ProcessIndicatorView(frame: indicatorFrame,
                                                 viewModel: viewModel,
                                                 normalIconImage: normalIconImage,
                                                 dimmedIconImage: dimmedIconImage)
        indicatorView.delegate = self
        indicatorView.index = processIndicatorViewList.count
        
        processIndicatorViewList.append(indicatorView)
        backgroundSlideView.addSubview(indicatorView)
                                
        setOrientations(for: indicatorView)
        reRangeIndicators()
    }
    
    func setOrientations(for indicatorView: ProcessIndicatorView) {
        if orientation == .horizontal {
            indicatorView.transform = CGAffineTransform(rotationAngle: 0)
        } else {
            indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
    }
    
    func getSlideContentSize() -> CGSize {
        guard processIndicatorViewList.count > 0 else {
            return backgroundSlideView.contentSize
        }
        
        let width = processIndicatorViewList.map{ $0.frame.width }.reduce(0, +) + span * CGFloat(processIndicatorViewList.count - 1)
        let height = backgroundSlideView.contentSize.height
        
        return CGSize(width: width, height: height)
    }
    
    func initialIndicatorActive() {
        getActiveIndicator()?.initialActiveStatus()
    }
    
    func setActiveIndicatorIndex(_ index: Int = 0, animated: Bool = false) {
        guard index < processIndicatorViewList.count else {
            return
        }
        
        activeIndicatorIndex = index
        
        guard let indicator = getActiveIndicator() else {
            return
        }
        
        indicator.isActive = true
        
        let slideContentSize = getSlideContentSize()
        let currentPositon = indicator.center
        let targetPosition = CGPoint(x: (backgroundSlideView.contentSize.width - slideContentSize.width) / 2 + iconLength / 2, y: 0)
        
        let offset = CGPoint(x: currentPositon.x - targetPosition.x, y: 0)
        backgroundSlideView.setContentOffset(offset, animated: animated)
    }
    
    private func getActiveIndicator() -> ProcessIndicatorView? {
        guard 0..<processIndicatorViewList.count ~= activeIndicatorIndex else {
            return nil
        }
    
        return processIndicatorViewList[activeIndicatorIndex]
    }
    
    func setProgress(_ progress: Float) {
        getActiveIndicator()?.progress = progress
    }
}

extension ProcessIndicatorContainer: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let kMaxIndex = processIndicatorViewList.count - 1

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
        
        if targetIndex != activeIndicatorIndex {
            setActiveIndicatorIndex(targetIndex)
            getActiveIndicator()?.handleTap()
            deactiveInactiveIndicators()
            
            guard let processIndicatorView = getActiveIndicator() else { return }
            didActive(processIndicatorView.progress)
        }
    }
}

extension ProcessIndicatorContainer: ProcessIndicatorViewDelegate {
    private func deactiveInactiveIndicators() {
        processIndicatorViewList
            .filter { $0.index != activeIndicatorIndex }
            .forEach { $0.deactive() }
    }
    
    func didActive(_ processIndicatorView: ProcessIndicatorView) {
        if activeIndicatorIndex != processIndicatorView.index {
            setActiveIndicatorIndex(processIndicatorView.index, animated: true)
        }
        
        deactiveInactiveIndicators()
        didActive(processIndicatorView.progress)
    }
    
    func didTempReset(_ processIndicatorView: ProcessIndicatorView) {
        didTempReset()
    }
    
    func didRemoveTempReset(_ processIndicatorView: ProcessIndicatorView) {
        didRemoveTempReset(processIndicatorView.progress)
    }
}
