//
//  File.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import Combine

extension PatientProfile {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        @Published var isSessionsCountLoading: Bool = true
        @Published var stretchingHistory: [StretchSummary.Model] = []
        
        var confirmationMessage: String = ""
        
        var stretchingSessionsCount: Int {
            stretchingHistory.count
        }

        @Published var hasNotificationFromTherapist: Bool = false
        
        let authenticationService: AuthenticationServiceProtocol
        let stretchingService: StretchingServiceProtocol
        let navigationAction: (ProfileNavigationType) -> Void
        let hasNotificationFromTherapistSubject: CurrentValueSubject<Bool, Never>
        
        private var cancellables: [AnyCancellable] = []
        private var getStretchingHistoryTask: Task<Void, Never>?

        init(authenticationService: AuthenticationServiceProtocol,
             stretchingService: StretchingServiceProtocol,
             hasNotificationFromTherapistSubject: CurrentValueSubject<Bool, Never>,
             navigationAction: @escaping (ProfileNavigationType) -> Void) {
            self.authenticationService = authenticationService
            self.stretchingService = stretchingService
            self.hasNotificationFromTherapistSubject = hasNotificationFromTherapistSubject
            hasNotificationFromTherapist = hasNotificationFromTherapistSubject.value
            self.navigationAction = navigationAction
            
            getStretchingHistory()
            configureCancellables()
        }
        
        private func configureCancellables() {
            hasNotificationFromTherapistSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.hasNotificationFromTherapist = value
                }
                .store(in: &cancellables)
        }
        
        func getStretchingHistory() {
            getStretchingHistoryTask?.cancel()
            
            getStretchingHistoryTask = Task(priority: .userInitiated) { @MainActor in
                await stretchingService.getAllStretchingSessionsForCurrentUser { [weak self] result in
                    switch result {
                    case .success(let stretchingSessionsResponse):
                        self?.stretchingHistory = stretchingSessionsResponse
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
        case goToHistory([StretchSummary.Model])
        case goToTherapistCollaboration
        case goToEditProfile
    }
}
