# Inchworm

#Inchworm

A rule-style UI tool for adjusting values

<p align="center">
    <img src="logo.jpg" height="120" max-width="90%" alt="Inchworm" />
</p>

<p align="center">
    <img src="Images/horizontal1.png" height="380" alt="Inchworm" />
    <img src="Images/horizontal2.png" height="380" alt="Inchworm" />
    <img src="Images/horizontal3.png" height="380" alt="Inchworm" />
    <img src="Images/vertical.png" height="380" alt="Inchworm" />
</p>

## Requirements
* iOS 11.0+
* Xcode 10.0+

### CocoaPods

```ruby
pod 'Inchworm', '~> 0.1'
```

## Usage

* create a DialBoard

``` swift
let model1 = ProcessIndicatorModel(limitNumber: 30,
                                   normalIconImage: <NormalIconImage1>,
                                   dimmedIconImage: <DimmedIconImage1>)

let model2 = ProcessIndicatorModel(limitNumber: 40,
                                   normalIconImage: <NormalIconImage2>,
                                   dimmedIconImage: <DimmedIconImage2>)

let model3 = ProcessIndicatorModel(limitNumber: 20,
                                   normalIconImage: <NormalIconImage3>,
                                   dimmedIconImage: <DimmedIconImage3>)


let modelList = [model1, model2, model3]

let config = Inchworm.Config()

let board = createDialBoard(config: config, frame: <Your Frame>, processIndicatorModels: modelList, activeIndex: 1)
```

* The caller needs to conform DialBoardDelegate
```swift
public protocol DialBoardDelegate {
    func didGetOffsetRatio(_ board: DialBoard, indicatorIndex: Int, offsetRatio: Float)
}
```


<div>Icon used here is from <a href="https://www.flickr.com/photos/andreaskay/47331947062" title="Flickr">Flickr</a>. by Andreas Kay, is licensed by <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/" title="Attribution-NonCommercial-ShareAlike 2.0 Generic" target="_blank">CC BY-NC-SA 2.0</a></div>
