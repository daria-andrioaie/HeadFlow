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
                
                DrawingView(exercise: $viewModel.currentStretchingExecise)
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
            .customAlert(Alert(title: "Connect AirPods", message: "In order to complete the stretch, please connect your AirPods from the control panel or from settings."), isPresented: $motionManager.airpodsAreDisconnected, iconView: {
                Image(.airpods)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
            }, cancelView: {
                Button {
                    viewModel.navigationAction?(.cancelStretching)
                } label: {
                    Text("Cancel stretch")                        .foregroundColor(.oceanBlue.opacity(0.4))
                }
            }, actionView: {
                Button {
                    viewModel.openSettings()
                } label: {
                    Text("Go to settings")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 20))
                }
            })
        }
        
        var headerView: some View {
            HStack(alignment: .top) {
                abandonButton
                Spacer()
                timerView
            }
            .padding(.horizontal, 30)
        }
        
        var timerView: some View {
            VStack {
                Text("\(viewModel.timeRemaining)")
                    .padding()
                    .background(Color.diamond)
                    .clipShape(Circle())
                
                Button  {
                    viewModel.toggleTimer()
                } label: {
                    Image(systemName: viewModel.isTimerRunning ? "pause.fill" : "play.fill")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.danubeBlue)
                        .frame(height: 20)
                }
            }
        }
        
        var abandonButton: some View {
            Button {
                viewModel.navigationAction?(.cancelStretching)
            } label: {
                Text("Abandon")
            }
            .buttonStyle(.plain)
            .foregroundColor(.red)
            .font(.Main.light(size: 18))
        }
    }
}


struct StretchExecutorView_Previews: PreviewProvider {
    static var previews: some View {
        StretchExecutor.ContentView(viewModel: .init(stretchingExecise: .mock1))
    }
}
