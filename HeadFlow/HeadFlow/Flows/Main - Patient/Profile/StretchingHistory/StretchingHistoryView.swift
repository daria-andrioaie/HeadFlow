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
        
        var body: some View {
            ContainerWithNavigationBar(title: "Stretching history", leftButtonAction: viewModel.onBack) {
                StretchingSessionsVerticalList(patient: viewModel.patient,
                                               stretchingSessions: viewModel.stretchingHistory,
                                               feedbackService: viewModel.feedbackService)
            }
        }
    }
}

#if DEBUG
struct StretchingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            StretchingHistory.ContentView(viewModel: .init(patient: .mockPatient1,
                                                           stretchingHistory: StretchSummary.Model.mockedSet,
                                                           feedbackService: MockFeedbackService(),
                                                           onBack: {}))
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
#endif
