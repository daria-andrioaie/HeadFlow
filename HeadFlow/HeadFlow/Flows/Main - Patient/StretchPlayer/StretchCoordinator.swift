//
//  StretchCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import UIKit
import SwiftUI

class StretchCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.isHidden = true
        return navVC
    }()
    
    var rootViewController: UIViewController? {
        navigationController
    }
    
    let dependencies: DependencyContainer
    let finishAction: () -> Void
    
    private var isLoadingSession: Bool = true
    private var stretchingSet: [StretchingExercise] = []
    private var currentExerciseIndex: Int
    
    init(window: UIWindow,
         dependencies: DependencyContainer,
         finishAction: @escaping () -> Void) {
        self.window = window
        self.dependencies = dependencies
        self.finishAction = finishAction
        currentExerciseIndex = 0
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showLoadingScreenScreen()
    }
    
    func showLoadingScreenScreen() {
        let countdownScreenVM = CountdownScreen.ViewModel(stretchingService: dependencies.stretchingService,
                                                          motionManager: dependencies.motionManager) { [weak self] stretchingSession in
            self?.stretchingSet = stretchingSession
            self?.dependencies.motionManager.startMotionUpdates()
            self?.showExerciseForCurrentIndex()
        }
        self.navigationController.pushHostingController(rootView: CountdownScreen.ContentView(viewModel: countdownScreenVM), animated: true)
    }

    
    func showExerciseForCurrentIndex() {
        if let currentExercise = stretchingSet[safe: currentExerciseIndex] {
            let currentExerciseVM = StretchExecutor.ViewModel(stretchingExecise: currentExercise, exerciseIndex: currentExerciseIndex + 1, totalNumberOfExercises: stretchingSet.count)
            
            currentExerciseVM.navigationAction = { [weak self] navigationType in
                switch navigationType {
                case .cancelStretching:
                    self?.finishAction()
                case .nextExercise(let currentExercise):
                    self?.saveCurrentExercise(currentExercise)
                    self?.currentExerciseIndex += 1
                    self?.showExerciseForCurrentIndex()
                }
            }
            self.navigationController.pushHostingController(rootView: StretchExecutor.ContentView(viewModel: currentExerciseVM, motionManager: dependencies.motionManager))
        } else {
            showStretchingSummary()
        }
    }
    
    private func saveCurrentExercise(_ exercise: StretchingExercise) {
        stretchingSet[currentExerciseIndex] = exercise
    }
    
    private func showStretchingSummary() {
        var sumOfRanges: Double = 0
        var totalDuration: Int = 0
        for stretch in stretchingSet {
            sumOfRanges += stretch.achievedRangeOfMotion ?? 0
            totalDuration += stretch.duration
        }
        
        let rangeOfMotion = sumOfRanges / Double(stretchingSet.count)
        let date = Date.now.millisecondsSince1970
        let summary = StretchSummary.Model(id: "\(date)", averageRangeOfMotion: rangeOfMotion, duration: totalDuration, exerciseData: stretchingSet, date: date)
        
        let viewModel = StretchSummary.ViewModel(summary: summary, stretchingService: dependencies.stretchingService, finishAction: { [weak self] in
            self?.finishAction()
        })
        
        self.navigationController.pushHostingController(rootView: StretchSummary.ContentView(viewModel: viewModel))
    }
}
