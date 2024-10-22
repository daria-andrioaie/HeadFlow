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
                    if let collaboration = viewModel.collaboration {
                        collaborationView(collaboration: collaboration)
                    } else {
                        noCollaborationView
                    }
                }
                .padding(24)
                .activityIndicator(viewModel.isLoading)
            }
        }
        
        @ViewBuilder
        func collaborationView(collaboration: Collaboration) -> some View {
            if viewModel.presentSuccessAnimation {
                AnimatedCheckmarkView(animationDuration: 2) {
                    viewModel.presentSuccessAnimation = false
                }
            } else if collaboration.status == .pending {
                pendingCollaborationView(collaboration: collaboration)
            } else {
                activeCollaborationView(collaboration: collaboration)
            }
        }
        
        func pendingCollaborationView(collaboration: Collaboration) -> some View {
            VStack(spacing: 30) {
                Text("You have a pending invitation from")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.medium(size: 18))
                
                therapistInfoView(therapist: collaboration.therapist)
                    .padding(.bottom, 40)
                
                respondToInvitationButtons
                Spacer()
            }
        }
        
        func activeCollaborationView(collaboration: Collaboration) -> some View {
            VStack(spacing: 30) {
                therapistInfoView(therapist: collaboration.therapist)
                    .padding(.bottom, 20)
                
                interruptCollaborationButton
                Spacer()
            }
        }
        
        func therapistInfoView(therapist: User) -> some View {
            VStack {
                profileImageView(imageURL: therapist.profilePicture)
                    .padding(.bottom, 30)
                
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
                    
                    HStack {
                        Image(systemName: "envelope")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Text(therapist.email)
                            .font(.Main.regular(size: 16))
                        
                    }
                    .foregroundColor(.oceanBlue.opacity(0.6))
                }
            }
        }
        
        func profileImageView(imageURL: URL?) -> some View {
            HFAsyncImage(url: imageURL, placeholderImage: .profileImagePlaceholder)
                .frame(width: 160, height: 160)
                .clipShape(Circle())
        }
        
        var respondToInvitationButtons: some View {
            HStack(spacing: 30) {
                Buttons.BorderedButton(title: "Decline", rightIcon: .closeIcon, width: 130) {
                    viewModel.respondToInvitation(isAccepted: false)
                }
                
                Buttons.FilledButton(title: "Accept", rightIcon: .checkmarkIcon, width: 130) {
                    viewModel.respondToInvitation(isAccepted: true)
                }
            }
        }
        
        var interruptCollaborationButton: some View {
            Buttons.BorderedButton(title: "Interrupt collaboration", rightIcon: .closeIcon, width: 245) {
                viewModel.interruptCollaboration()
            }
        }
        
        var noCollaborationView: some View {
            Text(viewModel.failureMessage ?? "")
                .font(.Main.regular(size: 18))
                .foregroundColor(.oceanBlue)
                .multilineTextAlignment(.center)
        }
    }
}

struct TherapistCollaborationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            TherapistCollaboration.ContentView(
                viewModel: .init(
                    patientService: MockPatientService(),
                    hasNotificationFromTherapistSubject: .init(false),
                    onBack: { }))
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
