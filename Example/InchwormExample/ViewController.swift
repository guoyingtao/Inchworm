//
//  ViewController.swift
//  InchwormExample
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit
import Inchworm

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        createHorizontalSlider()
        createVerticalSlider()
    }
    
    func createHorizontalSlider() {
        let config = Config()
        let slider = createSlider(with: config)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            slider.heightAnchor.constraint(equalToConstant: 120),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
        
    func createVerticalSlider() {
        var config = Config()
        config.orientation = .vertical
        let slider = createSlider(with: config)

        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalToConstant: 120),
            slider.heightAnchor.constraint(equalToConstant: 400),
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func createSlider(with config: Config) -> UIView {
        let model1 = ProcessIndicatorModel(sliderValueRangeType: .unilateral(limit: 30, defaultValue: 10),
                                           normalIconImage: UIImage(named: "ic_flash_on")!.tinted(with: UIColor.white)!.cgImage!,
                                           dimmedIconImage: UIImage(named: "ic_flash_on")!.tinted(with: UIColor.gray)!.cgImage!)

        let model2 = ProcessIndicatorModel(sliderValueRangeType: .bilateral(limit: 40, defaultValue: 15),
                                           normalIconImage: UIImage(named: "settings")!.tinted(with: UIColor.white)!.cgImage!,
                                           dimmedIconImage: UIImage(named: "settings")!.tinted(with: UIColor.gray)!.cgImage!)

        let model3 = ProcessIndicatorModel(sliderValueRangeType: .bilateral(limit: 50, defaultValue: 0),
                                           normalIconImage: UIImage(named: "ic_camera_front")!.tinted(with: UIColor.white)!.cgImage!,
                                           dimmedIconImage: UIImage(named: "ic_camera_front")!.tinted(with: UIColor.gray)!.cgImage!)


        let modelList = [model1, model2, model3]
        
        let slider = Inchworm.createSlider(config: config, frame: .zero, processIndicatorModels: modelList, activeIndex: 1)
        slider.delegate = self
        
        view.addSubview(slider)
        
        return slider
    }
}

extension ViewController: Inchworm.SliderDelegate {
    func didGetOffsetRatio(_ slider: Inchworm.Slider, activeIndicatorIndex: Int, offsetRatio: Float) {
        print("No \(activeIndicatorIndex) indicator has a offset(\(offsetRatio))")
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
}

