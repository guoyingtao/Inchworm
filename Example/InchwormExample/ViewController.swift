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
        let dimmedIconImage = UIImage(named: "ic_flash_on")!.tinted(with: UIColor.gray)!.cgImage!
        slider.addIconWith(limitNumber: 30, normalIconImage: iconImage, dimmedIconImage: dimmedIconImage)
        
        let iconImage1 = UIImage(named: "settings")!.tinted(with: UIColor.white)!.cgImage!
        let dimmedIconImage1 = UIImage(named: "settings")!.tinted(with: UIColor.gray)!.cgImage!
        slider.addIconWith(limitNumber: 40, normalIconImage: iconImage1, dimmedIconImage: dimmedIconImage1)
        
        let iconImage2 = UIImage(named: "ic_camera_front")!.tinted(with: UIColor.white)!.cgImage!
        let dimmedIconImage2 = UIImage(named: "ic_camera_front")!.tinted(with: UIColor.gray)!.cgImage!
        slider.addIconWith(limitNumber: 20, normalIconImage: iconImage2, dimmedIconImage: dimmedIconImage2)
                
        view.addSubview(slider)
        slider.setActiveIndicatorIndex(1)
        
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

