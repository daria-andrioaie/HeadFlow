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
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Here you'll see detailed info about the session completed on")
                    .multilineTextAlignment(.center)
                Text("\(stretchingSession.date.toCalendarDate())")
            }
        }
    }
}

#if DEBUG
struct DetailedStretchingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedStretchingInfo.ContentView(stretchingSession: .mock1)
    }
}
#endif
