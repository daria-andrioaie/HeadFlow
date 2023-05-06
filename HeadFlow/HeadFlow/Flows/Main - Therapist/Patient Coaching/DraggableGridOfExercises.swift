//
//  DraggableGridOfExercises.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.05.2023.
//

import SwiftUI
extension PatientCoaching {
    struct DraggableGridOfExercises: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tailor your patient's session")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.semibold(size: 22))
                ScrollView {
                    VStack(spacing: 15) {
                        ExerciseCard(exerciseType: .rotateToLeft)
                        ExerciseCard(exerciseType: .tiltForward)
                        ExerciseCard(exerciseType: .tiltBackwards)
                        ExerciseCard(exerciseType: .tiltToRight)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct DraggableGridOfExercises_Previews: PreviewProvider {
    static var previews: some View {
        PatientCoaching.DraggableGridOfExercises(
            viewModel: .init(therapistService: MockTherapistService(),
                                                                  patient: .mockPatient1,
                                                                  navigationAction: { _ in })
        )
    }
}
#endif
