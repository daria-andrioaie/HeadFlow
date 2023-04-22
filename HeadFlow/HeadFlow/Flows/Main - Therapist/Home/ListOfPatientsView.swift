//
//  ListOfPatientsView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.

import SwiftUI

extension TherapistHome {
    struct ListOfPatientsView: View {
        
        @State private var isInvitationSheetShown: Bool = false
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                titleView
                
                if viewModel.collaborationsMap.isEmpty {
                    noPatientsView
                } else {
                    patientsTypeFilterView
                    listForSelectedPatientType
                }
            }
            .padding(.horizontal, 24)
            .activityIndicator(viewModel.isLoading)
            .errorDisplay(error: $viewModel.apiError)
            .sheet(isPresented: $isInvitationSheetShown) {
                SendInvitation.ContentView(viewModel: .init(therapistService: viewModel.therapistService))
            }
            .onAppear {
                viewModel.getCollaborationsList()
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
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        
        var noPatientsView: some View {
            VStack {
                // draw arrow here towards the sendInvitationButtonView
                Text("You have no patients yet. Try sending an invitation.")
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
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.collaborationsForSelectedStatus, id: \.self) { collaboration in
                        patientCard(patient: collaboration.patient)
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
        
        func patientCard(patient: User) -> some View {
            HStack {
                Text(patient.firstName)
                Text(patient.lastName)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
            .background(Color.white.cornerRadius(30))
        }
    }
}


struct ListOfPatientsView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistHome.ListOfPatientsView(viewModel: .init(therapistService: MockTherapistService(), navigationAction: { _ in }))
    }
}
