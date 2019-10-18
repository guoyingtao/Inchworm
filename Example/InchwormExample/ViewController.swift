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
        let slider = DialContainer(frame: CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width - 20, height: 100))
        
        let iconImage = UIImage(named: "ic_flash_on")!.tinted(with: UIColor.white)!.cgImage!
                
        slider.addIconWith(iconImage: iconImage, andLimitNumber: 30)
        view.addSubview(slider)
        slider.setActiveIndicator()
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

