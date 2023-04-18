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
            VStack {
                firstNameInputField
                lastNameInputField
                emailInputField
                    .padding(.bottom, 40)
                registerAsTherapistCheckbox
            }
        }
        
        var firstNameInputField: some View {
            HStack {
                Text("First name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
                Spacer()
                CustomTextField(inputText: $viewModel.firstNameInput, placeholder: Texts.Register.firstNameInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(width: UIScreen.main.bounds.width * 2/3)
            }
        }
        
        var lastNameInputField: some View {
            HStack {
                Text("Last name")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
                Spacer()
                CustomTextField(inputText: $viewModel.lastNameInput, placeholder: Texts.Register.lastNameInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(width: UIScreen.main.bounds.width * 2/3)

            }
        }
        
        var emailInputField: some View {
            HStack {
                Text("Email")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
                Spacer()
                CustomTextField(inputText: $viewModel.emailInput, placeholder: Texts.Register.emailInputPlaceholder)
                    .font(.Main.light(size: 16))
                    .frame(width: UIScreen.main.bounds.width * 2/3)
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
        Register.ContentView(viewModel: .init(navigationAction: { _ in }))
    }
}
#endif
