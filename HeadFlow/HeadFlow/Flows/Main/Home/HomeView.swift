//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI

struct Home {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack(spacing: 50) {
                Text("Welcome to home screen")
                Buttons.FilledButton(title: "Logout", action: viewModel.logout)
            }
            .toastDisplay(isPresented: $viewModel.isConfirmationMessagePresented, message: viewModel.confirmationMessage)
            .errorDisplay(error: $viewModel.apiError)
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), onLogout: { }))
    }
}
#endif
