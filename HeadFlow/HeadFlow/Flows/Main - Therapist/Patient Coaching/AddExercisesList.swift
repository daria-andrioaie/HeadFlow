//
//  AddExercisesList.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import SwiftUI

extension PatientCoaching {
    struct AddExercisesList: View {
        @ObservedObject var viewModel: ViewModel
        @Binding var isPresented: Bool
        
        @State private var addedExercises = [StretchingExercise]()
        
        var exercises: [StretchingExercise] {
            PlannedSession.defaultSession.filter { exrecise in
                !viewModel.copyOfPlannedSession.contains(exrecise)
            }
        }

        var body: some View {
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(exercises, id: \.type) { exercise in
                            BasicExerciseCard(exercise: exercise) {
                                addedExercises.append(exercise)
                            }
                        }
                    }
                    .padding(24)
                }
            }
        }
        
        var headerView: some View {
            HStack {
                grabberView
                    .frame(maxWidth: .infinity)
                    .overlay(doneButton,
                             alignment: .trailing)
                    .padding(.horizontal, 24)
            }
        }
        
        var grabberView: some View {
            Color.apricot
                .cornerRadius(20)
                .frame(width: 40, height: 7)
                .padding(.vertical, 16)
        }
        
        var doneButton: some View {
            Button {
                viewModel.copyOfPlannedSession.append(contentsOf: addedExercises)
                isPresented = false
            } label: {
                Text("Done")
                    .font(.Main.regular(size: 18))
                    .foregroundColor(.apricot)
            }
            .buttonStyle(.plain)
        }
    }
}

struct AddExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            PatientCoaching.AddExercisesList(
                viewModel: .init(therapistService: MockTherapistService(),
                                patient: .mockPatient1,
                                navigationAction: { _ in }),
                isPresented: .constant(true))
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
