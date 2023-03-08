//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI
import UserNotifications
import RealmSwift

struct Home {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @State private var showNotificationsAlert: Bool = false
        @State private var notificationsStatus: String = ""
        
        var body: some View {
            VStack(spacing: 50) {
                Text("Welcome to home screen")
                Buttons.FilledButton(title: "Logout", action: viewModel.logout)
            }
            .toastDisplay(isPresented: $viewModel.isConfirmationMessagePresented, message: viewModel.confirmationMessage)
            .errorDisplay(error: $viewModel.apiError)
            .alert("Notifications alert", isPresented: $showNotificationsAlert, actions: {
                Button {
                    
                } label: {
                    Text("go to settings")
                }

            }, message: {
                Text("The notifications are \(notificationsStatus) on this device. To disable them, go to settings")
            })
            .onAppear {
                setupNotifications()
            }
        }
        
        func setupNotifications() {
            let notificationsCenter = UNUserNotificationCenter.current()
            notificationsCenter.removePendingNotificationRequests(withIdentifiers: ["idk", "idk2"])

            notificationsCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                        if granted {
                            guard let currentUserId = Session.shared.currentUserID else {
                                return
                            }
                            
                            let realm = try! Realm()
                            
                            let permissionsForCurrentUser = realm.objects(NotificationsPermissions.self).filter("userID = %@", currentUserId).first
                            
                            if let permissionsForCurrentUser {
                                try! realm.write {
                                    permissionsForCurrentUser.notificationsStatusPresented = true
                                }
                            }
                        } else {
                            // tell the user he can go to settings and enable them
                        }
                    }
                case .denied:
                    notificationsStatus = "disabled"

                    guard let currentUserId = Session.shared.currentUserID else {
                        return
                    }
                    
                    let realm = try! Realm()
                    
                    let permissions = realm.objects(NotificationsPermissions.self)
                    
                    let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                    if let permissionsForCurrentUser {
                        if !permissionsForCurrentUser.notificationsStatusPresented {
                            showNotificationsAlert = true
                            try! realm.write {
                                permissionsForCurrentUser.notificationsStatusPresented = true
                            }
                            return
                        } else {
                            showNotificationsAlert = false
                            return
                        }
                    }
                    print("the notifications permissions status is not in the db for the current user")
                case .authorized:
                    notificationsStatus = "enabled"
                    guard let currentUserId = Session.shared.currentUserID else {
                        return
                    }
                    
                    let realm = try! Realm()
                    
                    let permissions = realm.objects(NotificationsPermissions.self)
                    
                    let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                    if let permissionsForCurrentUser {
                        if !permissionsForCurrentUser.notificationsStatusPresented {
                            showNotificationsAlert = true
                            try! realm.write {
                                permissionsForCurrentUser.notificationsStatusPresented = true
                            }
                            return
                        } else {
                            showNotificationsAlert = false
                            return
                        }
                    }
                    print("the notifications permissions status is not in the db for the current user")
                default:
                    return
                }
                
            }

            
            let content = UNMutableNotificationContent()
            content.title = "Ready for a new day?"
            content.body = "Start with some movement!"
            content.sound = .default
            
            let date = Date().addingTimeInterval(10)
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            //            var dateComponents = DateComponents()
            //            dateComponents.hour = 21
            //            dateComponents.minute = 2
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "idk", content: content, trigger: trigger)
            
            notificationsCenter.add(request) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
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
