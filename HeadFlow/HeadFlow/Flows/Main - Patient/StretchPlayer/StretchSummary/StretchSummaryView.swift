//
//  StretchSummaryView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.03.2023.
//

import SwiftUI

struct StretchSummary {
    struct ContentView: View {
        @ObservedObject var viewModel: StretchSummary.ViewModel
        @Namespace private var animation
        private let animatedShapeId = "shapeId"
        private let animatedTextId = "textId"
        
        var body: some View {
            VStack {
                congratulationsMessage
                    .padding(.top, 120)
                
                Spacer()
                stretchingSummaryView
                Spacer()
                savingView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
            .onAppear(perform: viewModel.saveStretchingSummary)
            .errorDisplay(error: $viewModel.apiError)
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
                        
                        Text(viewModel.summary.duration.toMinutesAndSecondsFormat())
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
                        Text("\(viewModel.summary.averageRangeOfMotion.toPercentage())%")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.bold(size: 18))
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        
        @ViewBuilder
        var savingView: some View {
            ZStack(alignment: .center) {
                Color.clear
                    .cornerRadius(15)
                if viewModel.isSaving {
                    savingIndicator
                } else {
                    backToHomeButton
                }
            }
            .frame(width:250, height: 100)
            .padding(.bottom, 150)
        }
        
        var backToHomeButton: some View {
            Button {
                viewModel.finishAction()
            } label: {
                VStack(spacing: 20) {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .frame(width: 70)
                        .foregroundColor(.danubeBlue)
                        .matchedGeometryEffect(id: animatedShapeId, in: animation)

                    Text("Back to home")
                        .frame(width: 200, height: 30, alignment: .center)
                        .foregroundColor(.danubeBlue)
                        .font(.Main.semibold(size: 20))
                        .matchedGeometryEffect(id: animatedTextId, in: animation)
                }
                .transaction { (tx) in
                    tx.animation = .easeInOut
                }
            }
            .buttonStyle(.plain)
        }
        
        var savingIndicator: some View {
            VStack(spacing: 20) {
                Text("Saving your progress")
                    .frame(width: 200, height: 30, alignment: .center)
                    .foregroundColor(.danubeBlue)
                    .font(.Main.semibold(size: 20))
                    .matchedGeometryEffect(id: animatedTextId, in: animation)
                ScalingDots()
                    .matchedGeometryEffect(id: animatedShapeId, in: animation)
    
            }
            .transaction { (tx) in
                tx.animation = .easeInOut
            }
        }
    }
}

#if DEBUG
struct StretchSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StretchSummary.ContentView(viewModel: .init(summary: .mock1, stretchingService: MockStretchingService(), finishAction: { }))
            .previewDevice(.iPhone13)
    }
}
#endif
