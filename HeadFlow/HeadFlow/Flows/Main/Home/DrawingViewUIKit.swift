//
//  DrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 15.03.2023.
//

import Foundation
import UIKit
import SwiftUI
import CoreMotion

struct UIDrawingView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DrawingViewController
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        return DrawingViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        
    }
}

class DrawingViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    var mainImageView: UIImageView = .init(frame: .init(origin: .zero, size: .init(width: 300, height: 300)))
    let APP = CMHeadphoneMotionManager()
    var lastPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainImageView)
    
        APP.delegate = self
        
        guard APP.isDeviceMotionAvailable else {
            return
        }
        APP.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion, error == nil else { return }
            self?.drawLine(from: self?.lastPoint ?? .zero, to: .init(x: motion.attitude.roll, y: 0))
            self?.lastPoint = .init(x: motion.attitude.roll, y: 0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APP.stopDeviceMotionUpdates()
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
      UIGraphicsBeginImageContext(view.frame.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        return
      }
      mainImageView.image?.draw(in: view.bounds)
      
      context.move(to: fromPoint)
      context.addLine(to: toPoint)
      
      context.setLineCap(.round)
      context.setBlendMode(.normal)
      context.setLineWidth(1)
        context.setStrokeColor(UIColor.red.cgColor)
      
      context.strokePath()
      
      mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      mainImageView.alpha = 1
      
      UIGraphicsEndImageContext()
    }
}
