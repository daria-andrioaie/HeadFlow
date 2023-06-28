//
//  ProfileView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import SwiftUI

struct TherapistProfile {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                NavigationBar(title: Texts.GeneralProfile.profileNavbarTitle, leftButtonAction: { viewModel.navigationAction(.goBack) } ) {
                    logoutButton
                }
                mainContent
            }
            .fillBackground()
            .sheet(isPresented: $viewModel.isImagePickerShown) {
                ImagePickerView(image: $viewModel.newProfileImage)
            }
            .onChange(of: viewModel.newProfileImage) { _ in
                viewModel.uploadImage()
            }
            .toastDisplay(isPresented: $viewModel.isConfirmationMessagePresented, message: viewModel.confirmationMessage)
        }
        
        var mainContent: some View {
            VStack {
                profilePictureView
                    .padding(.bottom, 20)
                inputFields
                    .padding(.bottom, 30)

                Spacer()
                saveButton
            }
            .activityIndicator(viewModel.isLoading)
            .errorDisplay(error: $viewModel.apiError)
            .padding(.all, 24)
        }
        
        var logoutButton: some View {
            Button {
                viewModel.logout()
            } label: {
                Image(.logoutIcon)
                    .renderingMode(.template)
                    .foregroundColor(.danubeBlue)
            }
            .buttonStyle(.plain)
        }
        
        var profilePictureView: some View {
            ZStack(alignment: .bottomTrailing) {
                if let chosenImage = viewModel.newProfileImage {
                    Image(uiImage: chosenImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                } else {
                    HFAsyncImage(url: viewModel.currentProfileImage, placeholderImage: .profileImagePlaceholder)
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                }
                
                editProfilePicureButton
            }
        }
        
        var editProfilePicureButton: some View {
            Button {
                viewModel.isImagePickerShown = true
            } label: {
                Image(systemName: "pencil")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.danubeBlue)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .shadow(radius: 10, x: 5, y: 5))
            }
            .buttonStyle(.plain)
        }
        
        var inputFields: some View {
            VStack(spacing: 16) {
                if !viewModel.phoneNumber.isEmpty {
                    phoneNumberField
                }
                
                firstNameInputField
                lastNameInputField
                emailInputField
            }
        }
        
        var firstNameInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("First name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                
                CustomTextField(inputText: $viewModel.firstName, placeholder: Texts.Register.firstNameInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var lastNameInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("Last name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                CustomTextField(inputText: $viewModel.lastName, placeholder: Texts.Register.lastNameInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var phoneNumberField: some View {
            HStack {
                Image(systemName: "phone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.danubeBlue.opacity(0.8))
                
                Text(viewModel.phoneNumber)
                    .font(.Main.light(size: 20))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        var emailInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                CustomTextField(inputText: $viewModel.email, placeholder: Texts.Register.emailInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var saveButton: some View {
            Buttons.FilledButton(title: Texts.GeneralProfile.saveButtonLabel, rightIcon: .checkmarkIcon, size: .small, width: 105) {
                viewModel.updateProfile()
            }
        }
    }
}


struct TherapistProfileView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistProfile.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), navigationAction: { _ in }))
    }
}
