//
//  EditProfileViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import Foundation

extension EditProfile {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var apiError: Error?
        
        let onBack: () -> Void
                
        init(onBack: @escaping () -> Void) {
            self.onBack = onBack
        }
    
        deinit {
        }
    }
}
