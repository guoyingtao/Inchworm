//
//  SliderRulerPositionInfoProvider.swift
//  Inchworm
//
//  Created by Yingtao Guo on 6/14/23.
//

import Foundation

protocol SliderRulerPositionInfoProvider {
    var slideRuler: SlideRuler! { get set }
    func getInitialOffsetRatio() -> CGFloat
    func getCentralDotOriginX() -> CGFloat
    func getRulerOffsetX(with progress: CGFloat) -> CGFloat
    func checkIsCenterPosition(with limit: CGFloat) -> Bool
    func getForceAlignCenterX() -> CGFloat
    func getOffsetRatio() -> CGFloat
    func handleOffsetRatioWhenScrolling(_ scrollView: UIScrollView)
}

extension SliderRulerPositionInfoProvider {
    func handleOffsetRatioWhenScrolling(_ scrollView: UIScrollView) {}
}

class LeftStyleSliderRulerPositionInfoProvider: SliderRulerPositionInfoProvider {
    var slideRuler: SlideRuler!
    
    func getInitialOffsetRatio() -> CGFloat {
        return 0
    }
    
    func getCentralDotOriginX() -> CGFloat {
        return slideRuler.pointer.frame.origin.x - slideRuler.dotWidth / 2
    }
    
    func getRulerOffsetX(with progress: CGFloat) -> CGFloat {
        return progress * slideRuler.scrollRulerView.frame.width
    }
    
    func checkIsCenterPosition(with limit: CGFloat) -> Bool {
        return abs(slideRuler.scrollRulerView.contentOffset.x) < limit
    }
    
    func getForceAlignCenterX() -> CGFloat {
        return 0
    }
    
    func getOffsetRatio() -> CGFloat {
        let offsetRatio = slideRuler.scrollRulerView.contentOffset.x / slideRuler.scrollRulerView.bounds.width
        return min(1, max(0, offsetRatio))
    }
}

class MiddleStyleSliderRulerPositionInfoProvider: SliderRulerPositionInfoProvider {
    var slideRuler: SlideRuler!
    
    func getInitialOffsetRatio() -> CGFloat {
        return 0.5
    }
    
    func getCentralDotOriginX() -> CGFloat {
        return slideRuler.frame.width - slideRuler.dotWidth / 2
    }
    
    func getRulerOffsetX(with progress: CGFloat) -> CGFloat {
        return progress * slideRuler.offsetValue + slideRuler.offsetValue
    }
    
    func checkIsCenterPosition(with limit: CGFloat) -> Bool {
        return abs(slideRuler.scrollRulerView.contentOffset.x - slideRuler.frame.width / 2) < limit
    }
    
    func getForceAlignCenterX() -> CGFloat {
        return slideRuler.frame.width / 2
    }
    
    func getOffsetRatio() -> CGFloat {
        guard slideRuler.offsetValue != 0 else {
            return 0
        }
        
        var offsetRatio = (slideRuler.scrollRulerView.contentOffset.x - slideRuler.offsetValue) / slideRuler.offsetValue
        
        if offsetRatio > 1 { offsetRatio = 1.0 }
        if offsetRatio < -1 { offsetRatio = -1.0 }
        
        return offsetRatio
    }
    
    func handleOffsetRatioWhenScrolling(_ scrollView: UIScrollView) {
        if scrollView.frame.width > 0 {
            slideRuler.sliderOffsetRatio = scrollView.contentOffset.x / scrollView.frame.width
        }
    }
}
