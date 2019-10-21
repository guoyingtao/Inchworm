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
    
    public init(limitNumber: Int, normalIconImage: CGImage?, dimmedIconImage: CGImage?) {
        self.limitNumber = limitNumber
        self.normalIconImage = normalIconImage
        self.dimmedIconImage = dimmedIconImage
    }
}

public func createDialBoard(config: Config = Config(), frame: CGRect, processIndicatorModels: [ProcessIndicatorModel], activeIndex: Int) -> DialBoard {
    let board: DialBoard = DialBoard(config: config, frame: frame)
                    
    processIndicatorModels.forEach {
        board.addIconWith(limitNumber: $0.limitNumber, normalIconImage: $0.normalIconImage, dimmedIconImage: $0.dimmedIconImage)
    }
    
    board.setActiveIndicatorIndex(activeIndex)
    
    return board
}

@objc public class Config: NSObject {
    @objc public dynamic var orientation: Orientation = .horizontal
    public var indicatorSpan: CGFloat = 50
    public var slideRulerSpan: CGFloat = 50
    public var spaceBetweenIndicatorAndSlideRule: CGFloat = 10
    
    public override init() {
        
    }
}

@objc public enum Orientation: Int {
    case horizontal
    case vertical
}
