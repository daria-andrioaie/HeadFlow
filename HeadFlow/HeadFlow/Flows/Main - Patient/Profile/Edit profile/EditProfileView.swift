//
//  EditProfileView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import SwiftUI

struct EditProfile {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: Texts.GeneralProfile.editProfileMenuLabel, leftButtonAction: viewModel.onBack) {
                VStack(spacing: 30) {
                    Text("Here you'll edit your profile")
                }
                .padding(.top, 24)
                .activityIndicator(viewModel.isLoading)
                .errorDisplay(error: $viewModel.apiError)
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile.ContentView(viewModel: .init(onBack: { }))
    }
}
