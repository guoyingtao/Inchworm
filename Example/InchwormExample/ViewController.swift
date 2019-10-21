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
    
    var horizontalWidthConstraint: NSLayoutConstraint!
    var horizontalHeightConstraint: NSLayoutConstraint!
    var horizontalCenterXConstraint: NSLayoutConstraint!
    var horizontalBottomConstraint: NSLayoutConstraint!
    
    var verticalWidthConstraint: NSLayoutConstraint!
    var verticalHeightConstraint: NSLayoutConstraint!
    var verticalCenterYConstraint: NSLayoutConstraint!
    var verticalTrailingConstraint: NSLayoutConstraint!
    
    var horizontal = true
    let config = Inchworm.Config()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
                
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
        
        let slider = createSlider(config: config, frame: .zero, processIndicatorModels: modelList, activeIndex: 1)
        slider.delegate = self        
        
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalWidthConstraint = slider.widthAnchor.constraint(equalToConstant: 300)
        horizontalHeightConstraint = slider.heightAnchor.constraint(equalToConstant: 120)
        horizontalCenterXConstraint = slider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        horizontalBottomConstraint = slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        verticalWidthConstraint = slider.widthAnchor.constraint(equalToConstant: 120)
        verticalHeightConstraint = slider.heightAnchor.constraint(equalToConstant: 400)
        verticalCenterYConstraint = slider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        verticalTrailingConstraint = slider.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        toggle()
    }
    
    @IBAction func toggle() {
        if horizontal {
            config.orientation = .horizontal
            
            NSLayoutConstraint.deactivate([
                verticalWidthConstraint,
                verticalHeightConstraint,
                verticalCenterYConstraint,
                verticalTrailingConstraint
            ])

            NSLayoutConstraint.activate([
                horizontalWidthConstraint,
                horizontalHeightConstraint,
                horizontalCenterXConstraint,
                horizontalBottomConstraint
            ])
            
        } else {
            config.orientation = .vertical
            
            NSLayoutConstraint.deactivate([
                horizontalWidthConstraint,
                horizontalHeightConstraint,
                horizontalCenterXConstraint,
                horizontalBottomConstraint
            ])
            
            NSLayoutConstraint.activate([
                verticalWidthConstraint,
                verticalHeightConstraint,
                verticalCenterYConstraint,
                verticalTrailingConstraint
            ])
        }
        
        horizontal = !horizontal
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

