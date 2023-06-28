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
    @Published var currentRoll: Double?
    @Published var currentPitch: Double?
    @Published var currentYaw: Double?
    @Published var airpodsAreDisconnected: Bool = false
    var sumOfRolls: Double = 0
    var countOfRolls: Int = 0
    
    var sumOfPitches: Double = 0
    var countOfPitches: Int = 0
    
    var sumOfYaws: Double = 0
    var countOfYaws: Int = 0
    
    var startingRoll: Double = 0
    var startingYaw: Double = 0
    var startingPitch: Double = 0

    override init() {
        super.init()
        motionManager.delegate = self
    }
    
    func startComputingCoordinatesInStraightPosition() {
        if !motionManager.isDeviceMotionActive {
            airpodsAreDisconnected = true
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) {
            [weak self] motion, error in
            guard let self = self, let motion = motion else {
                return
            }
            
            self.sumOfRolls += self.getRoll(from: motion.attitude.quaternion)
            self.countOfRolls += 1
            
            self.sumOfYaws += self.getYaw(from: motion.attitude.quaternion)
            self.countOfYaws += 1
            
            self.sumOfPitches += self.getPitch(from: motion.attitude.quaternion)
            self.countOfPitches += 1
        }
    }
    
    func stopComputingCoordinatesInStraightPosition() {
        motionManager.stopDeviceMotionUpdates()
        
        startingRoll = sumOfRolls / Double(countOfRolls)
        print("The average starting roll is: \(startingRoll)")
        
        startingPitch = sumOfPitches / Double(countOfPitches)
        print("The average starting pitch is: \(startingPitch)")
        
        startingYaw = sumOfYaws / Double(countOfYaws)
        print("The average starting yaw is: \(startingYaw)")
    }
    
    func startMotionUpdates() {
        if !motionManager.isDeviceMotionActive {
            airpodsAreDisconnected = true
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) {
            [weak self] motion, error in
            guard let self = self, let motion = motion else {
                return
            }
            
            self.computeCurrentCoordinates(motion: motion)
//            print(self.xyzText(motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw))
//
//            DispatchQueue.main.async { [weak self] in
//                self?.motion = motion
//            }
        }
    }
    
    private func computeCurrentCoordinates(motion: CMDeviceMotion) {
        DispatchQueue.main.async { [weak self] in
            self?.currentRoll = (self?.getRoll(from: motion.attitude.quaternion) ?? 0) - (self?.startingRoll ?? 0)
            self?.currentPitch = (self?.getPitch(from: motion.attitude.quaternion) ?? 0) - (self?.startingPitch ?? 0)
            self?.currentYaw = (self?.getYaw(from: motion.attitude.quaternion) ?? 0) - (self?.startingYaw ?? 0)
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
        str += String(format: "X: %.1f\n", degrees(x))
        str += String(format: "Y: %.1f\n", degrees(y))
        str += String(format: "Z: %.1f\n", degrees(z))
        return str
    }

    func degrees(_ radians: Double) -> Double {
        return 180 / .pi * radians
    }

    func getRoll(from quat: CMQuaternion) -> Double {
        return self.degrees(atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z))
    }
    
    func getPitch(from quat: CMQuaternion) -> Double {
        return self.degrees(atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z));
    }
    
    func getYaw(from quat: CMQuaternion) -> Double {
        return self.degrees(asin(2*quat.x*quat.y + 2*quat.w*quat.z));
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
