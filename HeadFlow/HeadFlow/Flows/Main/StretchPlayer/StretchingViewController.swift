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
        
        init(dependencies: DependencyContainer) {
            self.dependencies = dependencies
            self.viewModel = ViewModel()
            
            super.init(rootView: ContentView(viewModel: viewModel))
            
            viewModel.navigationAction = { [weak self] navigationType in
                switch navigationType {
                case .goBack:
                    self?.navigationController?.popViewController(animated: false)
                }
            }
        }

        
        @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
