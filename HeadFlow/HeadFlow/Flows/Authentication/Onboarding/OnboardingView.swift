//
//  Onboarding.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct Onboarding {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                Onboarding.CarouselView()
                    .padding(.vertical, 45)
                authenticationButtons
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
        }
        
        var authenticationButtons: some View {
            HStack {
                Spacer()
                Buttons.BorderedButton(title: "Log In", borderColor: .feathers) {
                    viewModel.navigateToLogin()
                }
                Spacer()
                Buttons.BorderedButton(title: "Sign Up", width: 200) {
                    viewModel.navigateToRegister()
                }
                
            }
            .padding(.horizontal, 24)
        }
    }
}

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding.ContentView(viewModel: .init(navigateToRegister: { }, navigateToLogin: { }))
    }
}
#endif
