//
//  LoginView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import SwiftUI

struct Login {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: {
                viewModel.onLoginNavigation?(.goBack)
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
            }
            .onTapGesture(perform: hideKeyboard)
        }
        
        var greetingView: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(Texts.Login.greetingsLabel)
                    .font(.Main.bold(size: 26))
                    .foregroundColor(.danubeBlue)
                Text(Texts.Login.loginLabel)
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var phoneNumberField: some View {
            CustomTextField(inputText: viewModel.phoneNumberBinding, placeholder: Texts.Login.phoneFieldPlaceholder, keyboardType: .numberPad, inputError: viewModel.invalidPhoneNumberError)
                .font(.Main.light(size: 16))
        }
        
        var socialLoginView: some View {
            VStack(spacing: 15) {
                Text(Texts.Login.alternativesLabel)
                    .font(.Main.p1Regular)
                    .foregroundColor(.danubeBlue)
                HStack(spacing: 15) {
                    Image(.appleIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                    Image(.facebookIcon)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Image(.googleIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
        
        var nextButton: some View {
            Buttons.FilledButton(title: Texts.Login.nextButtonLabel, rightIcon: .chevronRightBold, isEnabled: viewModel.nextButtonIsEnabled, size: .small, width: 105) {
                viewModel.loginAction()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login.ContentView(viewModel: .init())
    }
}
#endif
