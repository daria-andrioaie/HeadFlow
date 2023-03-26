//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI
import CoreMotion
import SceneKit

struct Home {    
    struct ContentView: View {
        @ObservedObject var viewModel: HomeViewModel
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                profileButton
            }
            .fillBackground()

        }
        
        var profileButton: some View {
            Button {
                viewModel.navigationAction(.goToProfile)
            } label: {
                Image(.userProfileFilled)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.3), radius: 20, x: 5, y: 5)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 40)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}



#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home.ContentView(viewModel: HomeViewModel(navigationAction: { _ in }))
    }
}
#endif
