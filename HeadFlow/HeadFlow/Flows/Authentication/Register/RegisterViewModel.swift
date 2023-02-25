//
//  RegisterViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import Foundation
import SwiftUI

extension Register {
    class ViewModel: ObservableObject {
        @Published var nameInput: String = "" {
            didSet {
                if !nameInput.isEmpty {
                    nextButtonIsEnabled = true
                } else {
                    nextButtonIsEnabled = false
                }
            }
        }
        @Published var nextButtonIsEnabled: Bool = false
        
        var navigationAction: (RegisterNavigationType) -> Void
        
        init(navigationAction: @escaping (RegisterNavigationType) -> Void) {
            self.navigationAction = navigationAction
        }
        
        func onNext() {
            navigationAction(.next(nameInput))
        }
    }
    
    enum RegisterNavigationType {
        case goBack
        case next(String)
    }
}
