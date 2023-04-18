//
//  StretchingHistoryViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

extension StretchingHistory {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = true
        @Published var apiError: Error?
        var stretchingHistory: [StretchSummary.Model] = []
        
        let stretchingService: StretchingServiceProtocol
        let onBack: () -> Void
        
        private var getStretchingHistoryTask: Task<Void, Error>?
        
        init(stretchingService: StretchingServiceProtocol, onBack: @escaping () -> Void) {
            self.stretchingService = stretchingService
            self.onBack = onBack
            
            getStretchingHistory()
        }
        
        func getStretchingHistory() {
            getStretchingHistoryTask?.cancel()
            getStretchingHistoryTask = Task(priority: .userInitiated) { @MainActor in
                await stretchingService.getAllStretchingSessionsForCurrentUser { [weak self] result in
                    switch result {
                    case .success(let stretchingSessionsResponse):
                        self?.stretchingHistory = stretchingSessionsResponse
                        self?.isLoading = false
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
        deinit {
            getStretchingHistoryTask?.cancel()
        }
    }
}
