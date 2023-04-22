//
//  SwiftUIView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import SwiftUI

struct PatientProfile {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: Texts.GeneralProfile.profileNavbarTitle, leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack(spacing: 20) {
                    stretchingHistoryCard
                    MenuItemView(item: .therapistCollaboration, hasNotification: viewModel.hasNotificationFromTherapist) {
                        viewModel.navigationAction(.goToTherapistCollaboration)
                    }
                    MenuItemView(item: .editProfile) {
                        viewModel.navigationAction(.goToEditProfile)
                    }
                    Spacer()
                    Buttons.LogoutButton {
                        viewModel.logout()
                    }
                }
                .padding(.horizontal, 24)
                .toastDisplay(isPresented: $viewModel.isConfirmationMessagePresented, message: viewModel.confirmationMessage)
            }
        }
        
        var stretchingHistoryCard: some View {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(Texts.Stretching.stretchingHistoryLabel)
                        .foregroundColor(.diamond)
                        .font(.Main.bold(size: 18))
                    
                    HStack(spacing: 10) {
                        Text(Texts.Stretching.totalSessionsLabel)
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

#if DEBUG
struct PatientProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PatientProfile.ContentView(viewModel: .init(authenticationService: MockAuthenticationService(), stretchingService: MockStretchingService(), navigationAction: { _ in }))
    }
}
#endif
