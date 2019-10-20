//
//  Inchworm.swift
//  Inchworm
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

struct ProcessIndicatorModel {
    var limitNumber = 0
    var normalIconImage: CGImage?
    var dimmedIconImage: CGImage?
}

func createDialBoard(frame: CGRect, processIndicatorModels: [ProcessIndicatorModel], activeIndex: Int) -> DialBoard {
    let board = DialBoard(frame: frame)
    
    processIndicatorModels.forEach{
        board.addIconWith(limitNumber: $0.limitNumber, normalIconImage: $0.normalIconImage, dimmedIconImage: $0.dimmedIconImage)
    }
    
    board.setActiveIndicatorIndex(activeIndex)
    
    return board
}
