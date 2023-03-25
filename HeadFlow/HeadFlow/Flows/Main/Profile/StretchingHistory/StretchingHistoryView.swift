//
//  StretchingHistoryView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import SwiftUI

struct StretchingHistory {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @State private var selectedSession: StretchSummary.Model? = nil
        
        var body: some View {
            ContainerWithNavigationBar(title: "Stretching history", leftButtonAction: viewModel.onBack) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.stretchingHistory, id: \.self) { stretchingSession in
                            stretchingSessionCard(stretchingSession: stretchingSession)
                                .onTapGesture {
                                    selectedSession = stretchingSession
                                }
                        }
                    }
                }
                .padding(.all, 24)
                .activityIndicator(viewModel.isLoading)
                .errorDisplay(error: $viewModel.apiError)
            }
            .sheet(item: $selectedSession) { session in
                DetailedStretchingInfo.ContentView(stretchingSession: session)
            }
        }
        
        func stretchingSessionCard(stretchingSession: StretchSummary.Model) -> some View {
            HStack {
                VStack {
                    Text("Range of motion")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.medium(size: 18))
                        .opacity(0.6)
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(stretchingSession.averageRangeOfMotion.toPercentage())")
                            .font(.Main.bold(size: 24))
                        Text("%")
                            .font(.Main.bold(size: 30))
                    }
                    .foregroundColor(.oceanBlue)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.diamond.opacity(0.5)))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Duration")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.medium(size: 18))
                        .opacity(0.6)
                    Text("\(stretchingSession.duration.toHoursAndMinutesFormat()) min")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.bold(size: 18))
                        .padding(.bottom, 5)
                    
                    Text("Date")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.medium(size: 18))
                        .opacity(0.6)
                    Text("\(stretchingSession.date.toCalendarDate())")
                        .foregroundColor(.oceanBlue)
                        .font(.Main.bold(size: 18))
                }
                .padding(.all, 25)
            }
            .frame(maxWidth: .infinity)
            .roundedBorder(.danubeBlue, cornerRadius: 30, lineWidth: 1)
            .background(Color.white.cornerRadius(20))
        }
    }
}


struct StretchingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StretchingHistory.ContentView(viewModel: .init(stretchingService: MockStretchingService(), onBack: {}))
    }
}
