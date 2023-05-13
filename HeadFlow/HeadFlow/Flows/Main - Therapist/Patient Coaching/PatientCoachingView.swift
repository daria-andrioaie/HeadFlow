//
//  PatientCoachingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 30.04.2023.
//

import SwiftUI

struct PatientCoaching {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @State private var isPatientInfoCardPresented: Bool = false
        
        var body: some View {
            VStack {
                NavigationBar(title: viewModel.patientName, leftButtonAction: { viewModel.navigationAction(.goBack) } ) {
                    patientInfoButton
                }
                mainContent
            }
            .fillBackground()
        }
        
        var mainContent: some View {
            ZStack {
                VStack(spacing: 30) {
                    patientHistoryCardView
                    PatientCoaching.DraggableGridOfExercises(viewModel: viewModel)
                }
                if isPatientInfoCardPresented {
                    patientInfoCardView
                        .zIndex(1)
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        var patientInfoButton: some View {
            Button {
                withAnimation {
                    isPatientInfoCardPresented.toggle()
                }
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor(.danubeBlue)
            }
            .buttonStyle(.plain)
        }
        
        @ViewBuilder
        var patientInfoCardView: some View {
            let patient = viewModel.patient
            
            VStack {
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
                    
                    HStack {
                        Image(systemName: "envelope")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Text(patient.email)
                            .font(.Main.regular(size: 16))
                        
                    }
                    .foregroundColor(.oceanBlue.opacity(0.6))
                }
            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color.diamond
                .roundedCorners([.bottomLeft, .bottomRight, .topLeft], radius: 20)
                .shadow(radius: 8, x: 10, y: 10))
            .frame(maxHeight: .infinity, alignment: .top)
            .transition(.scale(scale: 0.1, anchor: .topTrailing))
        }
        
        func profileImageView(imageURL: URL?) -> some View {
            Image(systemName: "person.fill")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 70)
                .foregroundColor(.gray.opacity(0.3))
                .padding(30)
                .background(Color.white.clipShape(Circle()))
        }
        
        var patientHistoryCardView: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(Texts.Stretching.currentRangeOfMotionLabel)
                        .foregroundColor(.diamond)
                        .font(.Main.regular(size: 16))
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(viewModel.lastRangeOfMotion.toPercentage())")
                            .font(.Main.bold(size: 24))
                        Text("%")
                            .font(.Main.bold(size: 28))
                    }
                    .foregroundColor(.diamond)
                    .activityIndicator(viewModel.isLoadingHistory, scale: 0.8, tint: .feathers)
                }
                Spacer()
                Buttons.FilledButton(title: Texts.Stretching.seeProgressButtonLabel, rightIcon: .chevronRightBold, backgroundColor: .diamond, foregroundColor: .danubeBlue, size: .small, width: 155, font: .Main.semibold(size: 16)) {
                    viewModel.navigationAction(.goToHistory(viewModel.patient, viewModel.stretchingHistory))
                }
            }
            .padding(EdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 24))
            .frame(maxWidth: .infinity)
            .background(Color.oceanBlue.opacity(0.9).cornerRadius(20))
        }
    }
}

#if DEBUG
struct PatientCoachingView_Previews: PreviewProvider {
    static var previews: some View {
        PatientCoaching.ContentView(viewModel: .init(therapistService: MockTherapistService(), patient: .mockPatient1, navigationAction: { _ in }))
    }
}
#endif
