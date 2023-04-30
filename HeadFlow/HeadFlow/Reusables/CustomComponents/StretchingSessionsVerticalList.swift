//
//  StretchingSessionsVerticalList.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 30.04.2023.
//

import Foundation
import SwiftUI

struct StretchingSessionsVerticalList: View {
    @State private var selectedSession: StretchSummary.Model? = nil

    let stretchingSessions: [StretchSummary.Model]
    
    var body: some View {
        if stretchingSessions.isEmpty {
            emptyHistoryView
        } else {
            VStack(spacing: 30) {
                if #available(iOS 16.0, *) {
                    AnimatedChartView(stretchingHistory: stretchingSessions)
                        .frame(height: 200)
                        .padding(.horizontal, 40)
                }
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(stretchingSessions, id: \.self) { stretchingSession in
                            stretchingSessionCard(stretchingSession: stretchingSession)
                                .frame(height: 150)
                                .onTapGesture {
                                    selectedSession = stretchingSession
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
            .sheet(item: $selectedSession) { session in
                DetailedStretchingInfo.ContentView(stretchingSession: session)
            }
        }
    }
    
    func stretchingSessionCard(stretchingSession: StretchSummary.Model) -> some View {
        GeometryReader { proxy in
            HStack {
                VStack {
                    Text("Mobility")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 14))
                        .opacity(0.6)
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(stretchingSession.averageRangeOfMotion.toPercentage())")
                            .font(.Main.bold(size: 28))
                        Text("%")
                            .font(.Main.bold(size: 34))
                    }
                    .foregroundColor(.oceanBlue)
                    
                }
                .padding(.horizontal, 20)
                .frame(width: 0.4 * proxy.size.width)
                .frame(maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.diamond))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Duration")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 18))
                        .opacity(0.5)
                    Text("\(stretchingSession.duration.toMinutesAndSecondsFormat()) min")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.bold(size: 18))
                        .padding(.bottom, 5)
                    
                    Text("Date")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.regular(size: 18))
                        .opacity(0.5)
                    Text("\(stretchingSession.date.toCalendarDate())")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.bold(size: 18))
                }
                .padding(EdgeInsets(top: 25, leading: 0, bottom: 25, trailing: 45))
            }
            .frame(maxWidth: .infinity)
            .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
            .background(Color.white.cornerRadius(30))
        }
    }
    
    var emptyHistoryView: some View {
        VStack(spacing: 25) {
            Image(.shoudler_shrug)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Text(Texts.Stretching.noHistoryOfStretching)
                .font(.Main.regular(size: 18))
                .foregroundColor(.oceanBlue)
                .multilineTextAlignment(.center)
        }
    }
}


#if DEBUG
struct StretchingSessionsVerticalList_Previews: PreviewProvider {
    static var previews: some View {
        StretchingSessionsVerticalList(stretchingSessions: [])
    }
}
#endif
