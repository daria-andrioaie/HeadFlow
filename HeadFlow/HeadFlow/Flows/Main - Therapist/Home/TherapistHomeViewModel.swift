//
//  TherapistHomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation

extension TherapistHome {
    class ViewModel: ObservableObject {
        let navigationAction: (TherapistHome.NavigationType) -> Void
        
        init(navigationAction: @escaping (TherapistHome.NavigationType) -> Void) {
            self.navigationAction = navigationAction
        }
    }
}
    
extension TherapistHome {
    enum NavigationType {
        case goToProfile
    }
}
