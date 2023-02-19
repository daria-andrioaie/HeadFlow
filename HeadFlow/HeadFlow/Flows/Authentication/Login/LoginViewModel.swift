//
//  LoginViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import SwiftUI

extension Login {
    class ViewModel: ObservableObject {
        //TODO: validate and format phone number
        @Published var phoneNumber: String = "" {
            didSet {
                if phoneNumber.count == 12 {
                    nextButtonIsEnabled = true
                }
            }
        }
        @Published var nextButtonIsEnabled: Bool = false
        
        var onBack: () -> Void
        var onNext: () -> Void
        
        init(onBack: @escaping () -> Void, onNext: @escaping () -> Void) {
            self.onBack = onBack
            self.onNext = onNext
        }
        
        func loginAction() {
            //TODO: send sms code
            
            onNext()
        }
    }
}
