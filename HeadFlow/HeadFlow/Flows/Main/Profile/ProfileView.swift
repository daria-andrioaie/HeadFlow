//
//  SwiftUIView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import SwiftUI

struct Profile {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: "Profile", leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack {
                    Spacer()
                    Text("here you'll manage your profile")
                    Spacer()
                    Buttons.BorderedButton(title: "Logout") {
                        viewModel.navigationAction(.logout)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Profile.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), navigationAction: { _ in }))
    }
}
