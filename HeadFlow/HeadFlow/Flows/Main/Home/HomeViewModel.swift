//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation

    class HomeViewModel: ObservableObject {
        
        let navigationAction: (Home.NavigationType) -> Void
        
        init(navigationAction: @escaping (Home.NavigationType) -> Void) {
            self.navigationAction = navigationAction
        }
    
    }
    
extension Home {
    enum NavigationType {
        case startStretchCoordinator
        case goToProfile
    }
}
