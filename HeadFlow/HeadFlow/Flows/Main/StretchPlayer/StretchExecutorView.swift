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
                Button {
                    viewModel.navigationAction?(.goBack)
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
                .font(.Main.light(size: 18))
                .padding(.leading, 30)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                RobotHead()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
            
            .customAlert(Alert(title: "Connect AirPods", message: "In order to complete the stretch, please connect your AirPods from the control panel or from settings."), isPresented: $motionManager.airpodsAreDisconnected, iconView: {
                Image(.airpods)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
            }, cancelView: {
                Button {
                    viewModel.navigationAction?(.goBack)
                } label: {
                    Text("Cancel stretch")                        .foregroundColor(.oceanBlue.opacity(0.4))
                }
            }, actionView: {
                Button {
                    viewModel.navigationAction?(.goBack)
                } label: {
                    Text("Go to settings")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 20))
                }
            })
        }
    }
}


struct StretchExecutorView_Previews: PreviewProvider {
    static var previews: some View {
        StretchExecutor.ContentView(viewModel: .init())
    }
}
