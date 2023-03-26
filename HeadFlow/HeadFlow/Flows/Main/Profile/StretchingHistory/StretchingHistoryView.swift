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
                VStack(spacing: 30) {
                    if #available(iOS 16.0, *) {
                        AnimatedChartView(stretchingHistory: viewModel.stretchingHistory)
                            .frame(height: 200)
                            .padding(.horizontal, 40)
                    }
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.stretchingHistory, id: \.self) { stretchingSession in
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
                .padding(.top, 24)
                .activityIndicator(viewModel.isLoading)
                .errorDisplay(error: $viewModel.apiError)
            }
            .sheet(item: $selectedSession) { session in
                DetailedStretchingInfo.ContentView(stretchingSession: session)
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
    }
}

#if DEBUG
struct StretchingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            StretchingHistory.ContentView(viewModel: .init(stretchingService: MockStretchingService(), onBack: {}))
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
#endif
