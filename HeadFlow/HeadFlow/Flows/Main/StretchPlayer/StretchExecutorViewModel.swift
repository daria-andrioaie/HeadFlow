//
//  StretchExecutorViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import UIKit

extension StretchExecutor {
    class ViewModel: ObservableObject {
        @Published var areAripodsConnected: Bool = false
        var navigationAction: ((NavigationType) -> Void)?
        
        init() {
            
        }
        
        func openSettings() {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.tryOpen(url: settingsUrl)
        }
    }
    
    enum NavigationType {
        case goBack
    }
}
