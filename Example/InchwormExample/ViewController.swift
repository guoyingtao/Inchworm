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
        
        createHorizontalMiddleTypeSlider()
        createHorizontalLeftTypeSlider()        
        createVerticalMiddleTypeSlider()
    }
    
    func createHorizontalMiddleTypeSlider() {
        var config = Config()
        config.sliderZeroPositionType = .middle
        let slider = createSlider(with: config)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            slider.heightAnchor.constraint(equalToConstant: 120),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
    
    func createHorizontalLeftTypeSlider() {
        var config = Config()
        config.sliderZeroPositionType = .left
        
        let slider = createSlider(with: config)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            slider.heightAnchor.constraint(equalToConstant: 120),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func createVerticalMiddleTypeSlider() {
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
        let model1 = ProcessIndicatorModel(limitNumber: 30,
                                           normalIconImage: UIImage(named: "ic_flash_on")!.tinted(with: UIColor.white)!.cgImage!,
                                           dimmedIconImage: UIImage(named: "ic_flash_on")!.tinted(with: UIColor.gray)!.cgImage!)

        let model2 = ProcessIndicatorModel(limitNumber: 40,
                                           normalIconImage: UIImage(named: "settings")!.tinted(with: UIColor.white)!.cgImage!,
                                           dimmedIconImage: UIImage(named: "settings")!.tinted(with: UIColor.gray)!.cgImage!)

        let model3 = ProcessIndicatorModel(limitNumber: 40,
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

