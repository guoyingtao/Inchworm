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
    let config = Config()

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
        
        let board = createDialBoard(config: config, frame: .zero, processIndicatorModels: modelList, activeIndex: 1)
        board.delegate = self        
        
        view.addSubview(board)
        
        board.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalWidthConstraint = board.widthAnchor.constraint(equalToConstant: 300)
        horizontalHeightConstraint = board.heightAnchor.constraint(equalToConstant: 120)
        horizontalCenterXConstraint = board.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        horizontalBottomConstraint = board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        verticalWidthConstraint = board.widthAnchor.constraint(equalToConstant: 120)
        verticalHeightConstraint = board.heightAnchor.constraint(equalToConstant: 400)
        verticalCenterYConstraint = board.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        verticalTrailingConstraint = board.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        toggle()
    }
    
    @IBAction func toggle() {
        if horizontal {
            config.orientation = .horizontal
            
            horizontalWidthConstraint.isActive = true
            horizontalHeightConstraint.isActive = true
            horizontalCenterXConstraint.isActive = true
            horizontalBottomConstraint.isActive = true
            
            verticalWidthConstraint.isActive = false
            verticalHeightConstraint.isActive = false
            verticalCenterYConstraint.isActive = false
            verticalTrailingConstraint.isActive = false
        } else {
            config.orientation = .vertical
            
            horizontalWidthConstraint.isActive = false
            horizontalHeightConstraint.isActive = false
            horizontalCenterXConstraint.isActive = false
            horizontalBottomConstraint.isActive = false
            
            verticalWidthConstraint.isActive = true
            verticalHeightConstraint.isActive = true
            verticalCenterYConstraint.isActive = true
            verticalTrailingConstraint.isActive = true
        }
        
        horizontal = !horizontal
    }
}



extension ViewController: DialBoardDelegate {
    func didGetOffsetRatio(_ board: DialBoard, indicatorIndex: Int, offsetRatio: Float) {
        print("No \(indicatorIndex) indicator has a offset(\(offsetRatio))")
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

