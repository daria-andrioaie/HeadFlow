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
                SearchField(text: $inputEmail, placeholder: "Enter your patient's email address") {
                    viewModel.searchPatient(with: inputEmail)
                }
                resultView
            }
            .padding(30)
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
                    .frame(width: 0.6 * proxy.size.width)
                    .frame(maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.diamond))
                    
                    Spacer()
                    Button {
                        // send invitation
                    } label: {
                        VStack {
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
                    .padding(.trailing, 24)
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
            Text("We couldn't find any patient with the given email address. Please check the spelling.")
                .font(.Main.regular(size: 18))
                .foregroundColor(.oceanBlue)
                .multilineTextAlignment(.center)
        }
    }
}


struct SendInvitationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SendInvitation.ContentView(viewModel: .init(therapistService: MockTherapistService()))
    }
}
