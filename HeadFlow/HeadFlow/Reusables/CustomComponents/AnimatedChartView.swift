//
//  AnimatedChart.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 26.03.2023.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct AnimatedChartView: View {
    @State private var animateAppearance: Bool = false
    var stretchingHistory: [StretchSummary.Model]

    var body: some View {
        Chart {
            ForEach(stretchingHistory.sorted(by: {$0.date < $1.date})) { stretchingSession in
                LineMark(x: .value("Date", Date(milliseconds: stretchingSession.date), unit: .hour), y: .value("Range", animateAppearance ? stretchingSession.averageRangeOfMotion * 100 : 0))
                    .foregroundStyle(Color.danubeBlue.gradient)
                    .interpolationMethod(.catmullRom)
                PointMark(x: .value("Date", Date(milliseconds: stretchingSession.date), unit: .hour), y: .value("Range", animateAppearance ? stretchingSession.averageRangeOfMotion * 100 : 0))
                    .foregroundStyle(Color.oceanBlue)
                
                AreaMark(x: .value("Date", Date(milliseconds: stretchingSession.date), unit: .hour), y: .value("Range", animateAppearance ? stretchingSession.averageRangeOfMotion * 100 : 0))
                    .interpolationMethod(InterpolationMethod.catmullRom)
                    .foregroundStyle(Color.danubeBlue.opacity(0.1))
            }
        }
        .chartYScale(domain: 0...100)
        .onAppear {
            withAnimation(.spring(dampingFraction: 0.6)) {
                animateAppearance = true
            }
        }
    }
}

#if DEBUG
@available(iOS 16.0, *)
struct AnimatedChart_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedChartView(stretchingHistory: StretchSummary.Model.mockedSet)
            .frame(height: 400)
    }
}
#endif
