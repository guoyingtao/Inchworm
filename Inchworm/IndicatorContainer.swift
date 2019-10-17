//
//  IndicatorContainer.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class IndicatorContainer: UIView {

    var progressViewList: [CircularProgressView] = []

    var stackView = UIStackView()
    var backgroundSlideView = UIScrollView()
    
    var activeIndicator: CircularProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundSlideView.frame = self.frame
        let length = min(frame.width, frame.height)
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: length, height: length))
        progressViewList.append(progressView)
        
        progressViewList.forEach {
            stackView.addArrangedSubview($0)
        }
        
        activeIndicator = progressViewList.first!
        
        backgroundSlideView.addSubview(stackView)
        addSubview(backgroundSlideView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
