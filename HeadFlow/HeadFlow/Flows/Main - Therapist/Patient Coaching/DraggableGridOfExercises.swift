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
        @State private var offsets: [CGSize]
        @State private var isEditing: Bool = false
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            offsets = [CGSize](repeating: .zero, count: 8)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                if viewModel.isSavingPlan {
                    loadingSavingView
                } else {
                    planningView
                }
            }
        }
        
        var headerView: some View {
            HStack {
                Text("Tailor your patient's session")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.semibold(size: 22))
                Spacer()
                if isEditing {
                    HStack {
                        Button {
                            isEditing = false
                            viewModel.savePlannedSession()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            isEditing = false
                            viewModel.copyOfPlannedSession = viewModel.plannedSession
                        } label: {
                            Image(systemName: "xmark")
                                .renderingMode(.template)
                        }
                        .buttonStyle(.plain)
                    }
                    .foregroundColor(.danubeBlue)

                } else {
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(.danubeBlue)
                    }
                }
            }
        }
        
        var loadingSavingView: some View {
            VStack(spacing: 20) {
                Text("saving plan")
                    .foregroundColor(.danubeBlue)
                    .font(.Main.regular(size: 20))
                ScalingDots()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        
        var planningView: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    if isEditing {
                        ReorderableForEach($viewModel.copyOfPlannedSession, allowReordering: $isEditing) { exercise, isDragged in
                            let indexOfExercise = viewModel.copyOfPlannedSession.firstIndex(of: exercise)!
                            
                            ExerciseCard(exercise: $viewModel.copyOfPlannedSession[indexOfExercise], isEditing: isEditing, onDelete: {
                                print("removed exercise at \(indexOfExercise)")
                                withAnimation {
                                    viewModel.copyOfPlannedSession.remove(at: indexOfExercise)
                                }
                            })
                                .overlay(cardOverlay(isDragged: isDragged))
   
                        }
                    } else {
                        ReorderableForEach($viewModel.plannedSession, allowReordering: $isEditing) { exercise, isDragged in
                            let indexOfExercise = viewModel.plannedSession.firstIndex(of: exercise)!
                            
                            ExerciseCard(exercise: $viewModel.plannedSession[indexOfExercise], isEditing: isEditing)
                                .overlay(cardOverlay(isDragged: isDragged))
                        }
                    }
                }
                .padding(.bottom, 30)
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
        .previewDevice(.iPhone7Plus)
    }
}
#endif
