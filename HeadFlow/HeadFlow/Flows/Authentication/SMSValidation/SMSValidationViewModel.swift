//
//  SMSValidationViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

extension SMSValidation {
    class ViewModel: ObservableObject {
        var onNavigation: ((SMSValidationNavigationType) -> Void)?

    }
    
    enum SMSValidationNavigationType {
        case goBack
    }
}
