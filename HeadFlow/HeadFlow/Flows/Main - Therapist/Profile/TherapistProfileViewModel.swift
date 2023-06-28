//
//  ProfileViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation
import UIKit

extension TherapistProfile {
    class ViewModel: ObservableObject {
        @Published var newProfileImage: UIImage?
        @Published var currentProfileImage: URL?
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var email: String = ""
        @Published var phoneNumber: String = ""
        
        @Published var isImagePickerShown: Bool = false
        @Published var isLoading: Bool = false
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        var confirmationMessage: String = ""

        let authenticationService: AuthenticationServiceProtocol
        let navigationAction: (ProfileNavigationType) -> Void
        
        init(authenticationService: AuthenticationServiceProtocol, navigationAction: @escaping (ProfileNavigationType) -> Void) {
            self.authenticationService = authenticationService
            self.navigationAction = navigationAction
            populateInputFields()
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
                        self?.apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
        func updateProfile() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.updateProfile(firstName: firstName, lastName: lastName, email: email) { [weak self] result in
                    switch result {
                    case .success(let user):
                        self?.isConfirmationMessagePresented = true
                        self?.confirmationMessage = "Your profile was updated."
                        Session.shared.saveCurrentUser(user: user, token: Session.shared.accessToken!)
                    case .failure(let error):
                        self?.apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
        func uploadImage() {
            Task(priority: .userInitiated) { @MainActor in
                guard let newProfileImage else {
                    return
                }
                await authenticationService.updateProfilePicture(newProfileImage) { [weak self] result in
                    switch result {
                    case .success(let user):
                        Session.shared.saveCurrentUser(user: user, token: Session.shared.accessToken!)
                    case .failure(let error):
                        print(Errors.CustomError(error.message))
                    }
                }
            }
        }
        
        private func populateInputFields() {
            if let user = Session.shared.currentUser {
                firstName = user.firstName
                lastName = user.lastName
                email = user.email
                currentProfileImage = user.profilePicture
                phoneNumber = user.phoneNumber ?? ""
            }
        }
    }
    
    enum ProfileNavigationType {
        case goBack
        case logout
    }
}
