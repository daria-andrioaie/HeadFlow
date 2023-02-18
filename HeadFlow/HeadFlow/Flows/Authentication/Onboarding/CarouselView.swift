//
//  OnboardingCarouselView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import SwiftUI

extension Onboarding {
    struct CarouselView: View {
        @State private var selectedIndex = 0
        
        var body: some View {
            VStack {
                TabView(selection: $selectedIndex) {
                    VStack {
                        Color.skyBlue
                            .frame(width: 150, height: 200)
                        Text("Enhance mobility")
                            .font(.Main.semibold(size: 30))
                            .foregroundColor(.danubeBlue)
                            .padding(.vertical, 20)
                    }
                        .tag(0)
                    VStack {
                        Color.skyBlue
                            .frame(width: 150, height: 200)
                        Text("Sleep better")
                            .font(.Main.semibold(size: 30))
                            .foregroundColor(.danubeBlue)
                            .padding(.vertical, 20)
                    }
                        .tag(1)
                    VStack {
                        Color.skyBlue
                            .frame(width: 150, height: 200)
                        Text("Relax for a moment")
                            .font(.Main.semibold(size: 30))
                            .foregroundColor(.danubeBlue)
                            .padding(.vertical, 20)
                    }
                        .tag(2)
                }
                .frame(height: 400)
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
                HStack {
                    ForEach(0..<3) { index in
                        let isSelected = (index == selectedIndex)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? Color.danubeBlue : Color.skyBlue)
                            .frame(width: isSelected ? 20 :  10, height: 8)
                    }
                    .animation(.easeInOut, value: selectedIndex)
                }
            }
        }
    }
}

#if DEBUG
struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding.CarouselView()
    }
}
#endif
