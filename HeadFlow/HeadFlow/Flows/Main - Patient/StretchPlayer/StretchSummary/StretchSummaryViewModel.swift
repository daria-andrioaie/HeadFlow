//
//  StretchSummaryViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

extension StretchSummary {
    class ViewModel: ObservableObject {
        @Published var isSaving: Bool = true
        @Published var apiError: Error?
        
        let summary: StretchSummary.Model
        let stretchingService: StretchingServiceProtocol
        let finishAction: () -> Void
        
        private var saveTask: Task<Void, Error>?
        
        init(summary: StretchSummary.Model, stretchingService: StretchingServiceProtocol, finishAction: @escaping () -> Void) {
            self.summary = summary
            self.stretchingService = stretchingService
            self.finishAction = finishAction
        }
        
        func saveStretchingSummary() {
            saveTask?.cancel()
            
            saveTask = Task(priority: .userInitiated) { @MainActor in
                await stretchingService.saveStretchSummary(summary: summary, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.isSaving = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.apiError = Errors.CustomError(error.message)
                    }
                })
            }
        }
        
        deinit {
            saveTask?.cancel()
        }
    }
}
