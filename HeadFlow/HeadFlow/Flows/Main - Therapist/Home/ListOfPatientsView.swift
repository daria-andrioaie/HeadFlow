//
//  ListOfPatientsView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023

import SwiftUI

extension TherapistHome {
    struct ListOfPatientsView: View {
        
        @State private var isInvitationSheetShown: Bool = false
        @State private var isInvitationSent: Bool = false
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack(spacing: 30) {
                titleView
                patientsList
                    .activityIndicator(viewModel.isLoading)
            }
            .padding(.horizontal, 24)
            .errorDisplay(error: $viewModel.apiError)
            .sheet(isPresented: $isInvitationSheetShown) {
                SendInvitation.ContentView(viewModel:
                        .init(therapistService: viewModel.therapistService,
                              onSendInvitation: {
                    isInvitationSent = true
                }))
            }
            .onAppear {
                viewModel.getCollaborationsList()
            }
            .onChange(of: isInvitationSheetShown) { newValue in
                if !newValue && isInvitationSent {
                    viewModel.getCollaborationsList()
                    isInvitationSent = false
                }
            }
        }
        
        var titleView: some View {
            HStack {
                Text("Your patients")
                    .font(.Main.semibold(size: 24))
                    .foregroundColor(.danubeBlue)
                Spacer()
                sendInvitationButtonView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        @ViewBuilder
        var patientsList: some View {
            if viewModel.isDataSourceEmpty {
                noPatientsView
            } else {
                patientsTypeFilterView
                listForSelectedPatientType
            }
        }
        
        var noPatientsView: some View {
            VStack(spacing: 25) {
                Image(.shoudlerShrug)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                Text("You have no patients yet.\n Try sending an invitation.")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.oceanBlue)
                    .multilineTextAlignment(.center)
            }
            .frame(maxHeight: .infinity)
        }
        
        var patientsTypeFilterView: some View {
            HStack(spacing: 16) {
                Buttons.PillButton(title: "Active", isSelected: viewModel.selectedCollaborationStatus == .active) {
                    viewModel.selectedCollaborationStatus = .active
                }
                Buttons.PillButton(title: "Pending", isSelected: viewModel.selectedCollaborationStatus == .pending) {
                    viewModel.selectedCollaborationStatus = .pending
                }
            }
        }
        
        @ViewBuilder
        var listForSelectedPatientType: some View {
            if viewModel.collaborationsForSelectedStatus.isEmpty {
                Text(viewModel.noPatientsMessage)
                        .font(.Main.regular(size: 18))
                        .foregroundColor(.oceanBlue)
                        .multilineTextAlignment(.center)
                        .frame(maxHeight: .infinity, alignment: .center)
            }
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.collaborationsForSelectedStatus, id: \.self) { collaboration in
                        patientCard(collaboration: collaboration)
                    }
                }
            }
        }
        
        var sendInvitationButtonView: some View {
            Button {
                isInvitationSheetShown = true
            } label: {
                Image(.userAddLight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
            }
            .buttonStyle(.plain)
        }
        
        @ViewBuilder
        func patientCard(collaboration: Collaboration) -> some View {
            let patient = collaboration.patient
            Button {
                if collaboration.status == .active {
                    viewModel.navigationAction(.goToPatientCoaching(patient))
                }
            } label: {
                HStack(spacing: 20) {
                    profileImageView(imageURL: patient.profilePicture)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(patient.firstName) \(patient.lastName)")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.semibold(size: 24))
                        if let phoneNumber = patient.phoneNumber {
                            HStack {
                                Image(systemName: "phone")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text(phoneNumber)
                                    .font(.Main.regular(size: 18))
                            }
                            .foregroundColor(.oceanBlue.opacity(0.6))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
                .background(Color.white.cornerRadius(12))
            }
            .buttonStyle(.plain)
        }
        
        func profileImageView(imageURL: URL?) -> some View {
            HFAsyncImage(url: imageURL, placeholderImage: .profileImagePlaceholder)
            .frame(width: 90, height: 90)
            .clipShape(Circle())
        }
    }
}

#if DEBUG
struct ListOfPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistHome.ListOfPatientsView(viewModel: .init(therapistService: MockTherapistService(), navigationAction: { _ in }))
    }
}
#endif
