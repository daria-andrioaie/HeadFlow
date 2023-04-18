//
//  DetailedStretchingInfoView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import SwiftUI

struct DetailedStretchingInfo {
    struct ContentView: View {
        @StateObject private var viewModel = ViewModel()
        let stretchingSession: StretchSummary.Model
        let exerciseRangeDict: [StretchType : Double]
        
        init(stretchingSession: StretchSummary.Model) {
            self.stretchingSession = stretchingSession
            exerciseRangeDict = stretchingSession.exerciseData.reduce([StretchType :  Double]() , { partialResult, exercise in
                var partialResult = partialResult
                partialResult[exercise.type] = exercise.achievedRangeOfMotion
                return partialResult
            })
        }
        
        var body: some View {
            VStack(spacing: 20) {
                headerView
                    .padding(.bottom, 30)
                titleView
                    .padding(.bottom, 30)
                leftRightComparisonsView
                    .padding(.bottom, 50)
                flexionExtensionComparisonView
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        var leftRightComparisonsView: some View {
            VStack(spacing: 15) {
                HStack {
                    Text("Left")
                    Spacer()
                    Text("Right")
                }
                .foregroundColor(.danubeBlue)
                .font(.Main.semibold(size: 22))
                .padding(.horizontal, 70)
                
                horizontalDivider
                
                tableRow(title: "Lateral tilt",
                         firstValue: exerciseRangeDict[.tiltToLeft] ?? 0,
                         secondValue: exerciseRangeDict[.tiltToRight] ?? 0)
                
                tableRow(title: "Lateral rotation",
                         firstValue: exerciseRangeDict[.rotateToLeft] ?? 0,
                         secondValue: exerciseRangeDict[.rotateToRight] ?? 0)
                
                tableRow(title: "Full rotation",
                         firstValue: exerciseRangeDict[.fullRotationLeft] ?? 0,
                         secondValue: exerciseRangeDict[.fullRotationRight] ?? 0)
            }
            .overlay(verticalDivider, alignment: .center)
            .padding(.horizontal, 40)
        }
        
        @ViewBuilder
        var flexionExtensionComparisonView: some View {
            let forwardFlexionValue = exerciseRangeDict[.tiltForward] ?? 0
            let backwardsExtensionValue = exerciseRangeDict[.tiltBackwards] ?? 0
            
            HStack {
                VStack(spacing: 12) {
                    Text("Forward flexion")
                        .foregroundColor(.danubeBlue)
                        .font(.Main.semibold(size: 16))
                    Text("\(forwardFlexionValue.toPercentage())%")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.light(size: 18))
                }
                Spacer()
                VStack(spacing: 12) {
                    Text("Backward extension")
                        .foregroundColor(.danubeBlue)
                        .font(.Main.semibold(size: 16))
                    Text("\(backwardsExtensionValue.toPercentage())%")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.light(size: 18))
                }
            }
            .padding(.horizontal, 40)
        }
        
        func tableRow(title: String, firstValue: Double, secondValue: Double) -> some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.Main.p1Medium)
                
                HStack {
                    Text("\(firstValue.toPercentage())%")
                    Spacer()
                    Text("\(secondValue.toPercentage())%")
                }
                .foregroundColor(.oceanBlue)
                .font(.Main.light(size: 18))
                .padding(.horizontal, 70)
            }
        }
        
        var horizontalDivider: some View {
            HorizontalLine()
                .stroke(style: StrokeStyle(lineWidth: 0.3, dash: [4]))
                .foregroundColor(.gray)
                .frame(height: 5)
        }
        
        var verticalDivider: some View {
            VerticalLine()
                .stroke(style: StrokeStyle(lineWidth: 0.3, dash: [5]))
                .foregroundColor(.gray)
        }
        
        var titleView: some View {
            VStack(spacing: 0) {
                Text("Progress over perfection 💪🏼")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.medium(size: 22))
                    .padding(.bottom, 20)
                
                Text("In this session, you achieved an average range of motion of ")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.Main.p1Medium)
                
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(stretchingSession.averageRangeOfMotion.toPercentage())")
                        .font(.Main.bold(size: 28))
                    Text("%")
                        .font(.Main.bold(size: 34))
                }
                .foregroundColor(.oceanBlue)
            }
            .padding(.horizontal, 24)
        }
        
        var headerView: some View {
            VStack {
                grabberView
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(stretchingSession.date.toCalendarDate())")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.regular(size: 16))
                            .opacity(0.8)
                        
                        Text("\(stretchingSession.duration.toMinutesAndSecondsFormat()) min")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.regular(size: 16))
                            .opacity(0.5)
                    }
                    
                    
                    Spacer()
                    
                    shareButtonView
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .background(Color.feathers.cornerRadius(25))
        }
        
        var shareButtonView: some View {
            Button {
                // export as pdf and share
            } label: {
                Image(.shareIcon)
                    .renderingMode(.template)
                    .foregroundColor(.oceanBlue.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        
        var grabberView: some View {
            Color.apricot
                .cornerRadius(20)
                .frame(width: 40, height: 7)
                .padding(.vertical, 15)
        }
    }
}

#if DEBUG
struct DetailedStretchingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            DetailedStretchingInfo.ContentView(stretchingSession: .mock1)
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
#endif
