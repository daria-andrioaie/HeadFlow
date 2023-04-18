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
            ContainerWithNavigationBar(title: "Profile", leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack {
                    Spacer()
                    Button {
                        viewModel.navigationAction(.logout)
                    } label: {
                        HStack {
                            Image(.logoutIcon)
                                .renderingMode(.template)
                            Text("Logout")
                                .font(.Main.medium(size: 18))
                        }
                        .foregroundColor(.danubeBlue)
                    }
                    .buttonStyle(.plain)
                }
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
