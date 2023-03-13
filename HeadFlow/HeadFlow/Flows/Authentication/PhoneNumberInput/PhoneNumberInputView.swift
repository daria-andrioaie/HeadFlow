//
//  LoginView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import SwiftUI
import GoogleSignInSwift

struct PhoneNumberInput {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack {
                    greetingView
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                    phoneNumberField
                        .padding(.bottom, 80)
                    
                    socialLoginView
                    Spacer()
                    nextButton
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
                .activityIndicator(viewModel.isLoading)
            }
            .onTapGesture(perform: hideKeyboard)
            .errorDisplay(error: $viewModel.apiError)
        }
        
        var greetingView: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.greetingsLabel)
                    .font(.Main.bold(size: 26))
                    .foregroundColor(.danubeBlue)
                Text(viewModel.infoLabel)
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var phoneNumberField: some View {
            CustomTextField(inputText: $viewModel.phoneNumber, placeholder: Texts.PhoneNumberInput.phoneFieldPlaceholder, keyboardType: .numberPad, inputError: viewModel.invalidPhoneNumberError)
                .font(.Main.light(size: 16))
        }
        
        var socialLoginView: some View {
            VStack(spacing: 15) {
                Text(viewModel.alternativesLabel)
                    .font(.Main.p1Regular)
                    .foregroundColor(.danubeBlue)
                HStack(spacing: 15) {
                    Image(.facebookIcon)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Button {
                        viewModel.signupWithGoogle()
                    } label: {
                        Image(.googleIcon)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        
        var nextButton: some View {
            Buttons.FilledButton(title: Texts.PhoneNumberInput.nextButtonLabel, rightIcon: .chevronRightBold, isEnabled: viewModel.nextButtonIsEnabled, size: .small, width: 105) {
                viewModel.onNext()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberInput.ContentView(viewModel: .init(screenType: .signup("Daria"), authenticationService: MockAuthenticationService(), presentationController: nil, navigationAction: { _ in }))
    }
}
#endif
