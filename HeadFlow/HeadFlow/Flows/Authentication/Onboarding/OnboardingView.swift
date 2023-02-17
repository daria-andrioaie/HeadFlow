//
//  Onboarding.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct Onboaridng {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                Text("Onboarding")
                HStack {
                    Button {
                        viewModel.navigateToLogin()
                    } label: {
                        Text("login")
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        viewModel.navigateToRegister()
                    } label: {
                        Text("register")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Onboaridng.ContentView(viewModel: .init(navigateToRegister: { }, navigateToLogin: { }))
    }
}
#endif
