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
                    stretchingHistoryCard
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
        
        var stretchingHistoryCard: some View {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Stretching history")
                        .foregroundColor(.diamond)
                        .font(.Main.bold(size: 18))
                    
                    HStack(spacing: 10) {
                        Text("Total sessions:")
                            .foregroundColor(.diamond)
                            .font(.Main.regular(size: 18))
                        Text("\(viewModel.stretchingSessionsCount)")
                            .foregroundColor(.diamond)
                            .font(.Main.regular(size: 18))
                            .activityIndicator(viewModel.isSessionsCountLoading, scale: 0.8, tint: .feathers)
                    }
                    
                }
                Spacer()
                Buttons.FilledButton(title: Texts.Stretching.seeStretchingHistoryButtonLabel, rightIcon: .chevronRightBold, backgroundColor: .diamond, foregroundColor: .danubeBlue, size: .small, width: 125) {
                    viewModel.navigationAction(.goToHistory)
                }
            }
            .padding(.all, 30)
            .frame(maxWidth: .infinity)
            .background(Color.oceanBlue.opacity(0.9).cornerRadius(20))
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Profile.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), stretchingService: MockStretchingService(), navigationAction: { _ in }))
    }
}
