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
        
        let board = createDialBoard(frame: .zero, processIndicatorModels: modelList, activeIndex: 1)
        board.delegate = self
        
        let config1 = Config()
        
        // CGRect(x: view.frame.width - 120, y: 40, width: 120, height: 400)
        let board1 = createDialBoard(config: config1, frame: .zero, processIndicatorModels: modelList, activeIndex: 1)
        board1.delegate = self
                
        let board2 = createDialBoard(frame: CGRect(x: 0, y: 100, width: 200, height: 100), processIndicatorModels: modelList, activeIndex: 1)
        board.delegate = self
        
        view.addSubview(board)
        view.addSubview(board1)
        view.addSubview(board2)
        
        board.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            board.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            board.heightAnchor.constraint(equalToConstant: 200),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            board.widthAnchor.constraint(equalToConstant: 300)
        ])

        board1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            board1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            board1.heightAnchor.constraint(equalToConstant: 600),
            board1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            board1.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        config1.orientation = .vertical
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

