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
            ContainerWithNavigationBar(title: Texts.GeneralProfile.profileNavbarTitle, leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack {
                    Spacer()
                    Buttons.LogoutButton {
                        viewModel.logout()
                    }
                }
                .toastDisplay(isPresented: $viewModel.isConfirmationMessagePresented, message: viewModel.confirmationMessage)
                .padding(.all, 24)
            }
        }
    }
}


struct TherapistProfileView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistProfile.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), navigationAction: { _ in }))
    }
}
