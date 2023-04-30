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
                NavigationBar(title: viewModel.patientName, leftButtonAction: viewModel.onBack) {
                    patientInfoButton
                }
                mainContent
                
            }
            .fillBackground()
        }
        
        var mainContent: some View {
            ZStack {
                VStack {
                    Text("Here you will manage your patient \(viewModel.patient.firstName) \(viewModel.patient.lastName)")
                }
                .padding(.horizontal, 24)
                if isPatientInfoCardPresented {
                    patientInfoCardView
                }
            }
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
            .padding(.horizontal, 30)
            .transition(.scale(scale: 0.1, anchor: .topTrailing))
//            .scaleEffect(isPatientInfoCardPresented ? 1 : 0.01, anchor: .topTrailing)
//            .animation(.easeIn, value: isPatientInfoCardPresented)
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
    }
}

#if DEBUG
struct PatientCoachingView_Previews: PreviewProvider {
    static var previews: some View {
        PatientCoaching.ContentView(viewModel: .init(therapistService: MockTherapistService(), patient: .mockPatient1, onBack: { }))
    }
}
#endif
