//
//  StretchExecutorViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

extension StretchExecutor {
    class ViewModel: ObservableObject {
        var navigationAction: ((NavigationType) -> Void)?
        
        init() {
            
        }
    }
    
    enum NavigationType {
        case goBack
    }
}
