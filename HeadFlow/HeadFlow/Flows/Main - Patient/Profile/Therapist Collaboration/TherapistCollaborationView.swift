//
//  TherapistCollaborationView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import SwiftUI

struct TherapistCollaboration {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: "Your therapist", leftButtonAction: viewModel.onBack) {
                VStack(spacing: 30) {
                    if let therapist = viewModel.collaboration?.therapist {
                        therapistCard(therapist)
                    } else {
                        noResultsView
                    }
                }
                .padding(24)
                .activityIndicator(viewModel.isLoading)
            }
            .onAppear {
                Session.shared.hasNotificationFromTherapist = false
            }
        }
        
        func therapistCard(_ therapist: User) -> some View {
            GeometryReader { proxy in
                HStack {
                    therapistInfoView(therapist: therapist)
                    .frame(width: 0.6 * proxy.size.width)
                    .frame(maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.diamond))
                    
                    
                    collaborationStatusView
                        .frame(width: 0.4 * proxy.size.width)

                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
                .background(Color.white.cornerRadius(30))
            }
        }
        
        func therapistInfoView(therapist: User) -> some View {
            HStack {
                profileImageView(imageURL: therapist.profilePicture)
                
                VStack(spacing: 16) {
                    Text("\(therapist.firstName) \(therapist.lastName)")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 18))
                    if let phoneNumber = therapist.phoneNumber {
                        HStack {
                            Image(systemName: "phone")
                                .renderingMode(.template)
                            Text(phoneNumber)
                                .font(.Main.regular(size: 16))

                        }
                        .foregroundColor(.oceanBlue.opacity(0.6))
                    }
                }
            }
        }
        
        var collaborationStatusView: some View {
            Text("pending invitation")
                .foregroundColor(.oceanBlue.opacity(0.6))
                .font(.Main.regular(size: 16))
        }
    
        func profileImageView(imageURL: URL?) -> some View {
            Image(systemName: "person.fill")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(.gray.opacity(0.3))
                .padding(10)
                .background(Color.white.roundedCorners(radius: 20))
        }
        
        var noResultsView: some View {
            Text(viewModel.failureMessage ?? "")
                .font(.Main.regular(size: 18))
                .foregroundColor(.oceanBlue)
                .multilineTextAlignment(.center)
        }
    }
}

struct TherapistCollaborationView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistCollaboration.ContentView(viewModel: .init(patientService: MockPatientService(), onBack: { }))
    }
}
