//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI
import CoreMotion
import SceneKit

struct PatientHome {    
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @StateObject var notificationsViewModel = NotificationsViewModel()
        
        var body: some View {
            mainContent
            .customAlert(notificationsViewModel.notificationsAlert, isPresented: $notificationsViewModel.isNotificationsAlertPresented, iconView: {
                Image(.bell)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.apricot)
                    .frame(width: 50)
            }, cancelView: {
                Button {
                    notificationsViewModel.isNotificationsAlertPresented = false
                } label: {
                    Image(systemName: "x.circle")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(.oceanBlue.opacity(0.4))
                        .padding(.leading, 6)
                }

            }, actionView: {
                Button {
                    notificationsViewModel.openSettings()
                    notificationsViewModel.isNotificationsAlertPresented = false
                } label: {
                    Text("Go to settings")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 20))
                }
            })
            .onAppear {
                notificationsViewModel.setupNotifications()
            }
            
        }
        
        var mainContent: some View {
            VStack(spacing: 50) {
                Spacer()
                Button {
                    viewModel.navigationAction(.startStretchCoordinator)
                } label: {
                    VStack(alignment: .center, spacing: 20) {
                        Triangle(radius: 15)
                            .fill(Color.danubeBlue.opacity(0.8))
                            .frame(width: 80, height: 80)
                            .shadow(color: .gray.opacity(0.3), radius: 20, x: 5, y: 5)
                            .offset(x: 5)
                        Text("Start stretching")
                            .font(.Main.regular(size: 20))
                            .foregroundColor(.oceanBlue)
                    }
                    .frame(width: 140)
                }
                .buttonStyle(.plain)
                Spacer()
                Buttons.ProfileButton(hasNotification: viewModel.hasNotificationFromTherapist) {
                    viewModel.navigationAction(.goToProfile)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
        }
    }
}

#if DEBUG
struct PatientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            PatientHome.ContentView(
                viewModel: PatientHome.ViewModel(
                patientService: MockPatientService(),
                hasNotificationFromTherapistSubject: .init(false),
                navigationAction: { _ in }))
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
#endif
