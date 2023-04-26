//
//  File.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

extension PatientProfile {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        @Published var isSessionsCountLoading: Bool = true
        
        var hasNotificationFromTherapist: Bool {
            Session.shared.hasNotificationFromTherapist
        }
        
        var confirmationMessage: String = ""
        var stretchingSessionsCount: Int = 0

        let authenticationService: AuthenticationServiceProtocol
        let stretchingService: StretchingServiceProtocol
        let navigationAction: (ProfileNavigationType) -> Void

        private var getStretchingHistoryTask: Task<Void, Never>?

        init(authenticationService: AuthenticationServiceProtocol, stretchingService: StretchingServiceProtocol, navigationAction: @escaping (ProfileNavigationType) -> Void) {
            self.authenticationService = authenticationService
            self.stretchingService = stretchingService
            self.navigationAction = navigationAction
            
            getStretchingHistory()
        }
        
        func getStretchingHistory() {
            getStretchingHistoryTask?.cancel()
            
            getStretchingHistoryTask = Task(priority: .userInitiated) { @MainActor in
                await stretchingService.getAllStretchingSessionsForCurrentUser { [weak self] result in
                    switch result {
                    case .success(let stretchingSessionsResponse):
                        self?.stretchingSessionsCount = stretchingSessionsResponse.count
                        self?.isSessionsCountLoading = false
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
        func logout() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.logout { [weak self] result in
                    switch result {
                    case .success(let message):
                        self?.isConfirmationMessagePresented = true
                        self?.confirmationMessage = message
                        DispatchQueue.main.asyncAfter(seconds: 2) {
                            self?.navigationAction(.logout)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.apiError = Errors.CustomError(error.message)
                        }
                    }
                }
            }
        }
        
        deinit {
            getStretchingHistoryTask?.cancel()
        }
    }
    
    enum ProfileNavigationType {
        case goBack
        case logout
        case goToHistory
        case goToTherapistCollaboration
        case goToEditProfile
    }
}
