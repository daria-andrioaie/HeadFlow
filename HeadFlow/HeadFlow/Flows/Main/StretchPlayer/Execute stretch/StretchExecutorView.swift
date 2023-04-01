//
//  StretchExecutorView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import SwiftUI

struct StretchExecutor {
    struct ContentView: View {
        @StateObject private var motionManager: MotionManager = MotionManager()
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                headerView
                .padding(.bottom, 60)
                
                Text("\(viewModel.currentStretchingExecise.type.title)")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 24))
                    .padding(.bottom, 20)
                
                DrawingView(exercise: $viewModel.currentStretchingExecise, motionManager: motionManager, isPaused: viewModel.timerState != .running)
                    .padding(.horizontal, 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
            .onReceive(viewModel.timer, perform: { _ in
                if viewModel.timeRemaining > 0 {
                    viewModel.timeRemaining -= 1
                } else {
                    viewModel.timer.upstream.connect().cancel()
                    viewModel.navigationAction?(.nextExercise)
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
}

#if DEBUG
struct StretchExecutorView_Previews: PreviewProvider {
    static var previews: some View {
        StretchExecutor.ContentView(viewModel: .init(stretchingExecise: .mock1))
    }
}
#endif
