//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation

extension PatientHome {
    class ViewModel: ObservableObject {
        let navigationAction: (PatientHome.NavigationType) -> Void
        
        init(navigationAction: @escaping (PatientHome.NavigationType) -> Void) {
            self.navigationAction = navigationAction
        }
    }
}
    
extension PatientHome {
    enum NavigationType {
        case startStretchCoordinator
        case goToProfile
    }
}
