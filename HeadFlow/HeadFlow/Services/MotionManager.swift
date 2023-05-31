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
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) {
            [weak self] motion, error in
            guard let self = self, let motion = motion else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.motion = motion
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
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

    func degrees(_ radians: Double) -> Double {
        return 180 / .pi * radians
    }

    func quaternionToEuler(quat: CMQuaternion) {
        let myRoll = self.degrees(atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z)) ;
        let myPitch = self.degrees(atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z));
        let myYaw = self.degrees(asin(2*quat.x*quat.y + 2*quat.w*quat.z));
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
