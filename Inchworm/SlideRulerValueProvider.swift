//
//  SlideRulerValueProvider.swift
//  InchwormExample
//
//  Created by Echo on 10/19/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

protocol SlideRulerValueProvider {
    func getSlideOffset(by frame: CGRect) -> CGFloat
    func getSlideContenSize(by frame: CGRect) -> CGSize
    func getSlideContentOffset(by frame: CGRect) -> CGPoint
    func getPointerFrame(by pointerWidth: CGFloat) -> CGRect
}
