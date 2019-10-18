//
//  ViewController.swift
//  InchwormExample
//
//  Created by Echo on 10/16/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let sliderWidth = view.frame.width - 20
        let slider = DialContainer(frame: CGRect(x: 0, y: view.frame.height - 200, width: sliderWidth, height: 100))
        slider.backgroundColor = .blue
        
        let iconImage = UIImage(named: "ic_flash_on")!.tinted(with: UIColor.white)!.cgImage!
        slider.addIconWith(iconImage: iconImage, andLimitNumber: 30)
        
        let iconImage1 = UIImage(named: "ic_camera_front")!.tinted(with: UIColor.white)!.cgImage!
        slider.addIconWith(iconImage: iconImage1, andLimitNumber: 20)

        let iconImage2 = UIImage(named: "settings")!.tinted(with: UIColor.white)!.cgImage!
        slider.addIconWith(iconImage: iconImage2, andLimitNumber: 40)
        
        view.addSubview(slider)
        slider.setActiveIndicator()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            slider.heightAnchor.constraint(equalToConstant: 100),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.widthAnchor.constraint(equalToConstant: sliderWidth)
        ])
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

