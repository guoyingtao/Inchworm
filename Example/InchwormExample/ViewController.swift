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
        
        let board = createDialBoard(frame: CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100), processIndicatorModels: modelList, activeIndex: 1)
                
        view.addSubview(board)
        
        board.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            board.heightAnchor.constraint(equalToConstant: 100),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            board.widthAnchor.constraint(equalToConstant: view.frame.width)
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

