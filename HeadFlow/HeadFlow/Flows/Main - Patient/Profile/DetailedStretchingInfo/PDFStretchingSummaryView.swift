//
//  PDFStretchingSummaryView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 13.05.2023.
//

import SwiftUI

extension DetailedStretchingInfo {
    struct PDFSummaryView: View {
        let patient: User
        let stretchingSession: StretchSummary.Model
        let exerciseRangeDict: [StretchType : Double]
        
        init(patient: User, stretchingSession: StretchSummary.Model) {
            self.patient = patient
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
                    .padding(.vertical, 15)
                titleView
                    .padding(.bottom, 30)
                leftRightComparisonsView
                    .padding(.bottom, 35)
                flexionExtensionComparisonView
                Spacer()
                footerView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        var headerView: some View {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(stretchingSession.date.toCalendarDate())")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 16))
                        .opacity(0.8)
                    
                    Text(stretchingSession.duration.toMinutesAndSecondsFormat())
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 16))
                        .opacity(0.5)
                }
                
                Spacer()
                
                Text(patient.firstName + " " + patient.lastName)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 16))
                    .opacity(0.8)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .background(Color.feathers.cornerRadius(25))
        }
        
        var titleView: some View {
            let patientName = Session.shared.currentUser?.firstName ?? "the patient"
            
            return VStack(spacing: 0) {
                Text("In this session, \(patientName) achieved an average range of motion of ")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.medium(size: 18))
                
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
        
        var footerView: some View {
            Text("Monitored by HeadFlow Inc.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.oceanBlue)
                .font(.Main.regular(size: 12))
                .opacity(0.5)
                .padding(24)
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
    }
}

struct PDFStretchingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            DetailedStretchingInfo.PDFSummaryView(
                patient: .mockPatient1,
                stretchingSession: .mock1)
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
