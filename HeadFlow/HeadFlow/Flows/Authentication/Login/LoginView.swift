//
//  LoginView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import SwiftUI
import iPhoneNumberField

struct Login {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: viewModel.onBack) {
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
                Text("Welcome back! 👋🏼")
                    .font(.Main.bold(size: 26))
                    .foregroundColor(.danubeBlue)
                Text("Let's get you logged in.")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var phoneNumberField: some View {
            iPhoneNumberField("Enter your number", text: $viewModel.phoneNumber)
                .defaultRegion("RO")
                .flagHidden(false)
                .flagSelectable(true)
                .prefixHidden(false)
                .font(UIFont(name: "Lato-Light", size: 18))
                .maximumDigits(10)
                .foregroundColor(Color.oceanBlue)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .roundedBorder(.oceanBlue, cornerRadius: 15, lineWidth: 0.5)
        }
        
        var socialLoginView: some View {
            VStack(spacing: 15) {
                Text("Or log in with:")
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
            Buttons.FilledButton(title: "Next", rightIcon: .chevronRightBold, isEnabled: viewModel.nextButtonIsEnabled, size: .small, width: 105) {
                viewModel.loginAction()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login.ContentView(viewModel: .init(onBack: { }, onNext: { }))
    }
}
#endif
