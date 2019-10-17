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
        let slider = SlideRuler(frame: CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width - 20, height: 40))
        slider.backgroundColor = .blue
        view.addSubview(slider)
    }

}

