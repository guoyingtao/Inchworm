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
}

public func createDialBoard(config: Config = Config(), frame: CGRect, processIndicatorModels: [ProcessIndicatorModel], indicatorLength: CGFloat = 50, activeIndex: Int) -> DialBoard {
    let board: DialBoard
    
    if config.orientation == .horizontal {
        board = DialBoard(orientation: config.orientation, frame: frame, indicatorLength: indicatorLength)
    } else {
        let newFrame = CGRect(x: frame.origin.x - (frame.height / 2 - frame.width / 2), y: frame.origin.y + frame.height / 2 - frame.width / 2, width: frame.height, height: frame.width)
        board = DialBoard(orientation: config.orientation, frame: newFrame, indicatorLength: indicatorLength)
        board.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
        
    processIndicatorModels.forEach {
        board.addIconWith(limitNumber: $0.limitNumber, normalIconImage: $0.normalIconImage, dimmedIconImage: $0.dimmedIconImage)
    }
    
    board.setActiveIndicatorIndex(activeIndex)
    
    return board
}

public class Config {
    var orientation: Orientation = .horizontal
    
    public init() {
        
    }
}

public enum Orientation {
    case horizontal
    case vertical
}
