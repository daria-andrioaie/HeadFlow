//
//  StretchExecutorView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import SwiftUI

struct StretchExecutor {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @ObservedObject var motionManager: MotionManager
        
        var body: some View {
            VStack {
                headerView
                .padding(.bottom, 60)
                
                Text("\(viewModel.currentStretchingExecise.type.prompt)")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 24))
                    .padding(.bottom, 20)
                
                DrawingView(exercise: $viewModel.currentStretchingExecise, motionManager: motionManager, isPaused: viewModel.timerState != .running)
                    .padding(.horizontal, 80)
                    .padding(.vertical, 50)
                
                TimelineView(currentExerciseIndex: viewModel.exerciseIndex, totalCount: viewModel.totalNumberOfExercises)
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
            .onReceive(viewModel.timer, perform: { _ in
                if viewModel.timeRemaining > 0 {
                    viewModel.timeRemaining -= 1
                } else {
                    viewModel.timer.upstream.connect().cancel()
                    viewModel.navigationAction?(.nextExercise(currentExercise: viewModel.currentStretchingExecise))
                }
            })
            .onChange(of: motionManager.airpodsAreDisconnected, perform: { newValue in
                newValue ? viewModel.disableTimer() : viewModel.enableTimer()
            })
            .customAlert(.airpodsAlert, isPresented: $motionManager.airpodsAreDisconnected,
                         iconView: { airpodsIcon },
                         cancelView: { abandonButton },
                         actionView: { goToSettingsButton })
            .onAppear {
                if motionManager.airpodsAreDisconnected {
                    viewModel.disableTimer()
                }
            }
        }
        
        private var headerView: some View {
            HStack(alignment: .top) {
                if !motionManager.airpodsAreDisconnected {
                    abandonButton
                }
                Spacer()
                timerView
            }
            .padding(.horizontal, 30)
        }
        
        private var timerView: some View {
            VStack {
                Text("\(viewModel.timeRemaining)")
                    .padding()
                    .background(Color.diamond)
                    .clipShape(Circle())
                
                Button  {
                    viewModel.toggleTimer()
                } label: {
                    timerImageBasedOnTimerState
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.danubeBlue)
                        .frame(height: 20)
                }
                .disabled(viewModel.timerState == .disabled)
                .buttonStyle(.plain)
            }
            .opacity(viewModel.timerState == .disabled ? 0.5 : 1)
        }
        
        private var timerImageBasedOnTimerState: Image {
            if viewModel.timerState == .running {
                return Image(systemName: "pause.fill")
            } else {
                return Image(systemName: "play.fill")
            }
        }
        
        private var abandonButton: some View {
            Button {
                viewModel.navigationAction?(.cancelStretching)
            } label: {
                Text("Abandon")
            }
            .buttonStyle(.plain)
            .foregroundColor(.red)
            .font(.Main.light(size: 18))
            .contentShape(Rectangle())
        }
        
        private var airpodsIcon: some View {
            Image(.airpods)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 140)
        }
        
        private var goToSettingsButton: some View {
            Button {
                viewModel.openSettings()
            } label: {
                Text("Go to settings")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 20))
            }
        }
    }
    
    struct TimelineView: View {
        let currentExerciseIndex: Int
        let totalCount: Int
        
        var body: some View {
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    ForEach(0 ..< totalCount - 1) { index in
                        Circle()
                            .fill(Color.danubeBlue)
                            .opacity(index < currentExerciseIndex ? 0.7 : 0.2)
                            .frame(width: 10, height: 10)
                        Rectangle()
                            .frame(height: 2.5)
                            .foregroundColor(.danubeBlue)
                            .opacity(index < currentExerciseIndex - 1 ? 0.7 : 0.2)
                    }
                    Circle()
                        .fill(Color.danubeBlue)
                        .opacity(currentExerciseIndex == totalCount ? 0.7 : 0.2)
                        .frame(width: 10, height: 10)
                }
                
                Text("\(currentExerciseIndex)/\(totalCount)")
                    .foregroundColor(.danubeBlue)
                    .font(.Main.semibold(size: 20))
            }
            .padding(.horizontal, 46)
        }
    }
}

#if DEBUG
struct StretchExecutorView_Previews: PreviewProvider {
    static var previews: some View {
        StretchExecutor.ContentView(viewModel: .init(stretchingExecise: .init(type: .tiltForward, duration: 5, goalDegrees: StretchType.rotateToRight.maximumDegrees, maximumDegrees: StretchType.rotateToRight.maximumDegrees), exerciseIndex: 3, totalNumberOfExercises: 8), motionManager: MotionManager())
    }
}
#endif
