//
//  SendInvitationSheetView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import SwiftUI

struct SendInvitation {
    struct ContentView: View {
        @State private var inputEmail: String = ""
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack(spacing: 30) {
                titleView
                SearchField(text: $inputEmail, placeholder: "Enter your patient's email address") {
                    viewModel.searchPatient(with: inputEmail)
                }
                resultView
            }
            .padding(30)
        }
        
        var titleView: some View {
            HStack {
                Text("Send an invitation")
                    .font(.Main.semibold(size: 24))
                    .foregroundColor(.danubeBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        @ViewBuilder
        var resultView: some View {
            VStack {
                if let patient = viewModel.patient {
                    patientCard(patient)
                    Spacer()
                } else if viewModel.failureMessage != nil {
                    noResultsView
                }
            }
            .activityIndicator(viewModel.isLoading)
            .frame(maxHeight: .infinity)
        }
        
        func patientCard(_ patient: User) -> some View {
            GeometryReader { proxy in
                HStack {
                    patientInfoView(patient: patient)
                    .frame(width: 0.65 * proxy.size.width)
                    .frame(maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.diamond))
                    
                    
                    invitationStatusView
                        .frame(width: 0.35 * proxy.size.width)

                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
                .background(Color.white.cornerRadius(30))
            }
        }
        
        func patientInfoView(patient: User) -> some View {
            HStack {
                profileImageView(imageURL: patient.profilePicture)
                
                VStack(spacing: 16) {
                    Text("\(patient.firstName) \(patient.lastName)")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 18))
                    if let phoneNumber = patient.phoneNumber {
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
        
        @ViewBuilder
        var invitationStatusView: some View {
            switch viewModel.invitationStatus {
            case .none:
                sendInvitationView
            case .sending:
                sendingInvitationView
            case .sent:
                sentInvitationView
            }
        }
        
        var sendInvitationView: some View {
            Button {
                viewModel.sendInvitation()
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.oceanBlue)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    Text("Send invitation")
                        .foregroundColor(.oceanBlue.opacity(0.6))
                        .font(.Main.regular(size: 16))
                }
            }
            .buttonStyle(.plain)
        }
        
        var sendingInvitationView: some View {
            VStack(spacing: 10) {
                ActivityIndicator(tint: .danubeBlue)
                    .frame(width: 20)
                Text("Sending")
                    .foregroundColor(.oceanBlue.opacity(0.6))
                    .font(.Main.regular(size: 16))
            }
        }
        
        var sentInvitationView: some View {
            VStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.oceanBlue)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("Sent!")
                    .foregroundColor(.oceanBlue.opacity(0.6))
                    .font(.Main.regular(size: 16))
            }
        }
        
        func profileImageView(imageURL: URL?) -> some View {
            HFAsyncImage(url: imageURL, placeholderImage: .profileImagePlaceholder)
            .frame(width: 60, height: 60)
            .clipShape(Circle())
        }
        
        var noResultsView: some View {
            Text(viewModel.failureMessage ?? "")
                .font(.Main.regular(size: 18))
                .foregroundColor(.oceanBlue)
                .multilineTextAlignment(.center)
        }
    }
}

#if DEBUG
struct SendInvitationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SendInvitation.ContentView(viewModel: .init(
            therapistService: MockTherapistService(),
            onSendInvitation: { })
        )
    }
}
#endif
