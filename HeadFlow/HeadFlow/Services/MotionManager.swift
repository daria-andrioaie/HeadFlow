//
//  MotionManager.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 13.03.2023.
//

import Foundation
import CoreMotion
import SwiftUI
import UIKit

class MotionManager: NSObject, ObservableObject {
    private var motionManager = CMHeadphoneMotionManager()
    @Published var text: String = ""
    @Published var motion: CMDeviceMotion?
    @Published var airpodsAreDisconnected: Bool = false

    override init() {
        super.init()
        checkConnection()
        startMotionUpdates()
    }
    
    private func checkConnection() {
        if !motionManager.isDeviceMotionActive {
            airpodsAreDisconnected = true
        }
    }
    
    private func startMotionUpdates() {
        motionManager.delegate = self
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            
            let attitude = motion.attitude
            let roll = self.degrees(attitude.roll)
            let pitch = self.degrees(attitude.pitch)
            let yaw = self.degrees(attitude.yaw)

            let r = motion.rotationRate
            let ac = motion.userAcceleration
            let g = motion.gravity

            DispatchQueue.main.async { [weak self] in
                self?.motion = motion
            }
        }

    }

    required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }


    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", num)
    }

    func xyzText(_ x: Double, _ y: Double, _ z: Double) -> String {
        // Absolute value just makes it look nicer
        var str = ""
        str += String(format: "X: %.1f\n", abs(x))
        str += String(format: "Y: %.1f\n", abs(y))
        str += String(format: "Z: %.1f\n", abs(z))
        return str
    }

    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension MotionManager: CMHeadphoneMotionManagerDelegate {
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        DispatchQueue.main.async { [weak self] in
            self?.airpodsAreDisconnected = false
        }
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        DispatchQueue.main.async { [weak self] in
            self?.airpodsAreDisconnected = true
        }
    }
}
