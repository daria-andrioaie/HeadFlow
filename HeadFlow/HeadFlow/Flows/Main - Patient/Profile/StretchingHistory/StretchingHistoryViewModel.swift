//
//  StretchingHistoryViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

extension StretchingHistory {
    class ViewModel: ObservableObject {
        let stretchingHistory: [StretchSummary.Model]
        let onBack: () -> Void
        
        init(stretchingHistory: [StretchSummary.Model], onBack: @escaping () -> Void) {
            self.stretchingHistory = stretchingHistory
            self.onBack = onBack
        }
    }
}
