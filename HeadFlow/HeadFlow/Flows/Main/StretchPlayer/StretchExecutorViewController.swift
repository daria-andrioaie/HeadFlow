//
//  StretchCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import UIKit
import SwiftUI

extension StretchExecutor {
    class ViewController: UIHostingController<ContentView> {
        private let viewModel: ViewModel
        private let dependencies: DependencyContainer
        private var stretchingSet: [StretchingExercise]
        private var currentExerciseIndex: Int
        
        init(dependencies: DependencyContainer) {
            self.dependencies = dependencies
            self.stretchingSet = Self.initStretchingSet()
            currentExerciseIndex = 0
            viewModel = ViewModel(stretchingExecise: stretchingSet[currentExerciseIndex])
            
            super.init(rootView: ContentView(viewModel: viewModel))
            
            viewModel.navigationAction = { [weak self] navigationType in
                switch navigationType {
                case .cancelStretching:
                    self?.navigateToHomescreen()
                case .nextExercise:
                    self?.saveCurrentExercise()
                    self?.navigateToNextExercise()
                }
            
            }
        }
        
        private func saveCurrentExercise() {
            stretchingSet[currentExerciseIndex] = viewModel.currentStretchingExecise
        }
        
        private func navigateToNextExercise() {
            currentExerciseIndex += 1
            if let nextExercise = stretchingSet[safe: currentExerciseIndex] {
                viewModel.currentStretchingExecise = nextExercise
            } else {
                showStretchingSummary()
            }
        }
        
        private func showStretchingSummary() {
            var sumOfRanges: Double = 0
            var totalDuration: Int = 0
            for stretch in stretchingSet {
                sumOfRanges += stretch.achievedRangeOfMotion ?? 0
                totalDuration += stretch.duration
            }
            
            let rangeOfMotion = sumOfRanges / Double(stretchingSet.count)
            let summary = StretchSummary.Model(averageRangeOfMotion: rangeOfMotion, duration: totalDuration, date: Date.now.millisecondsSince1970)
            
            let viewModel = StretchSummary.ViewModel(summary: summary, stretchingService: dependencies.stretchingService, finishAction: { [weak self] in
                self?.navigateToHomescreen()
            })
            
            self.navigationController?.pushHostingController(rootView: StretchSummary.ContentView(viewModel: viewModel))
        }
        
        private func navigateToHomescreen() {
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        static func initStretchingSet() -> [StretchingExercise] {
            //TODO: save a global variable in the database and take it from there
            let durationInSeconds = 5
            let stretchingSet = StretchType.allCases.map { stretchType in
                return StretchingExercise(type: stretchType, duration: durationInSeconds)
            }
//            let stretchingSet = [StretchingExercise(type: .tiltToRight, duration: 2)]
            return stretchingSet
        }
        
        @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
