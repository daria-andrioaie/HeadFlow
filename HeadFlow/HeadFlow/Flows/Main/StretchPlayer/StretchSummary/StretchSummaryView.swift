//
//  StretchSummaryView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.03.2023.
//

import SwiftUI

struct StretchSummary {
    struct ContentView: View {
        let averageRangeOfMotion: Double
        let totalDuration: Int
        let stretchinService: StretchingServiceProtocol
        let finishAction: () -> Void
        
        var body: some View {
            VStack {
                
                congratulationsMessage
                    .padding(.top, 120)
                
                Spacer()
                
                stretchingSummaryView
                
                Spacer()
                
                backToHomeButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
            .task {
                await stretchinService.saveStretchSummary(summary: .init(averageRangeOfMotion: averageRangeOfMotion, duration: totalDuration), onRequestCompleted: { _ in })
            }
        }
        
        var congratulationsMessage: some View {
            VStack(spacing: 20) {
                Text("Yey!")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 30))
                Text("You've completed the stretch!")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.h2SemiBold)
                Text("🎉")
                    .font(.Main.regular(size: 50))
            }
        }
        
        var stretchingSummaryView: some View {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "clock")
                        .renderingMode(.template)
                        .foregroundColor(.decoGreen)
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.medium(size: 18))
                            .opacity(0.6)
                        
                        Text("\(totalDuration) sec")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.bold(size: 18))
                    }
                }
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "arrow.left.and.right")
                        .renderingMode(.template)
                        .foregroundColor(.apricot)
                    VStack(alignment: .leading) {
                        Text("Range of motion")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.medium(size: 18))
                            .opacity(0.6)
                        Text("\(averageRangeOfMotion * 100)%")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.bold(size: 18))
                    }
                }
            }
            .padding(.horizontal, 60)
        }
        
        var backToHomeButton: some View {
            Button {
                finishAction()
            } label: {
                VStack {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(.danubeBlue)
                    Text("Back to home")
                        .frame(height: 30)
                        .foregroundColor(.danubeBlue)
                        .font(.Main.h2SemiBold)
                }
            }
            .buttonStyle(.plain)
            .padding(.bottom, 150)
        }
    }
}


struct StretchSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StretchSummary.ContentView(averageRangeOfMotion: 0.0, totalDuration: 45, stretchinService: MockStretchingService(), finishAction: { })
    }
}
