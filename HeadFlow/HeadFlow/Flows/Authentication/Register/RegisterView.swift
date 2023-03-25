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
                    nameInputField
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
                Text(Texts.Register.nameQuestion)
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var nameInputField: some View {
            CustomTextField(inputText: $viewModel.nameInput, placeholder: Texts.Register.nameInputPlaceholder)
                .font(.Main.light(size: 16))
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
