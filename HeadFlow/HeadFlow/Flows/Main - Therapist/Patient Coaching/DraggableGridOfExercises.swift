//
//  DraggableGridOfExercises.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.05.2023.
//

import SwiftUI
import SwiftUIReorderableForEach

extension PatientCoaching {
    struct DraggableGridOfExercises: View {
        @ObservedObject var viewModel: ViewModel
        @State private var exercises: [StretchType]
        @State private var offsets: [CGSize]
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            let exercises: [StretchType] = [.rotateToLeft,
                                            .tiltForward,
                                            .tiltBackwards,
                                            .tiltToRight,
                                            .rotateToRight]
            self.exercises = exercises
            offsets = [CGSize](repeating: .zero, count: exercises.count)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tailor your patient's session")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.semibold(size: 22))
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ReorderableForEach($exercises, allowReordering: .constant(false)) { exercise, isDragged in
                            let indexOfExercise = exercises.firstIndex(of: exercise)!
                            
                            ExerciseCard(exerciseType: exercise, offset: $offsets[indexOfExercise], onDelete: {
                                print("removed exercise at \(indexOfExercise)")
                                exercises.remove(at: indexOfExercise)
                            })
                                .overlay(cardOverlay(isDragged: isDragged))
                                .onAppear {
                                    print(offsets[indexOfExercise])
                                }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        
        @ViewBuilder
        func cardOverlay(isDragged: Bool) -> some View {
            if isDragged {
                Color.white
                    .opacity(0.7)
                    .cornerRadius(15)
            } else {
                Color.clear
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
        .padding(.horizontal, 24)
    }
}
#endif
