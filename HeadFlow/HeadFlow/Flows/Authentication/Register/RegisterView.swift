//
//  RegisterView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct Register {
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
                    inputFields
                        .padding(.bottom, 30)
                    
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
                Text(Texts.Register.getToKnowYouLabel)
                    .font(.Main.bold(size: 26))
                    .foregroundColor(.danubeBlue)
                //                Text(Texts.Register.nameQuestion)
                //                    .font(.Main.regular(size: 18))
                //                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var inputFields: some View {
            VStack(spacing: 16) {
                firstNameInputField
                lastNameInputField
                emailInputField
                    .padding(.bottom, 40)
                registerAsTherapistCheckbox
            }
        }
        
        var firstNameInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("First name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                
                CustomTextField(inputText: $viewModel.firstNameInput, placeholder: Texts.Register.firstNameInputPlaceholder, textInputAutoCapitalization: .words)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var lastNameInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("Last name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                CustomTextField(inputText: $viewModel.lastNameInput, placeholder: Texts.Register.lastNameInputPlaceholder, textInputAutoCapitalization: .words)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var emailInputField: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue.opacity(0.8))
                CustomTextField(inputText: $viewModel.emailInput, placeholder: Texts.Register.emailInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(maxWidth: .infinity)
            }
        }
        
        var registerAsTherapistCheckbox: some View {
            HStack {
                Text(Texts.Register.registerAsTherapist)
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
                Buttons.Checkbox(isChecked: viewModel.userTypeBinding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            Register.ContentView(viewModel: .init(navigationAction: { _ in }))
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
#endif
