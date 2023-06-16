<p align="center">
    <img src="Images/logo.png" height="120" max-width="90%" alt="Inchworm" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/swift-5.0-orange.svg" alt="swift 5.0 badge" />
    <img src="https://img.shields.io/badge/platform-iOS-lightgrey.svg" alt="platform iOS badge" />
    <img src="https://img.shields.io/badge/license-MIT-black.svg" alt="license MIT badge" />   
</p>

# Inchworm

A slider for adjusting values just like the one in Photo.app in iOS 13

<p align="center">
    <img src="Images/demo.png" height="380" alt="Inchworm" />
    <img src="Images/demo-bilateral.png" height="380" alt="Inchworm" />
    <img src="Images/demo-unilateral.png" height="380" alt="Inchworm" />
</p>

## Requirements
* iOS 11.0+
* Xcode 10.0+

### CocoaPods

```ruby
pod 'Inchworm', '~> 1.0.0'
```

## Usage

* Create a Slider

``` swift
let model1 = ProcessIndicatorModel(sliderValueRangeType: .unilateral(limit: 30),
                                   normalIconImage: <NormalIconImage1>,
                                   dimmedIconImage: <DimmedIconImage1>)

let model2 = ProcessIndicatorModel(sliderValueRangeType: .bilateral(limit: 40),
                                   normalIconImage: <NormalIconImage2>,
                                   dimmedIconImage: <DimmedIconImage2>)

let model3 = ProcessIndicatorModel(sliderValueRangeType: .bilateral(limit: 50),
                                   normalIconImage: <NormalIconImage3>,
                                   dimmedIconImage: <DimmedIconImage3>)


let modelList = [model1, model2, model3]

let config = Inchworm.Config()

let board = createSlider(config: config, frame: <Your Frame>, processIndicatorModels: modelList, activeIndex: 1)
```

* The caller needs to conform DialBoardDelegate
```swift
public protocol SliderDelegate {
func didGetOffsetRatio(_ slider: Inchworm.Slider, activeIndicatorIndex: Int, offsetRatio: Float)
}
```

<div><a href="https://www.flaticon.com/free-icons/worm" title="worm icons">Worm icons created by Freepik - Flaticon</a></div>
