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
        @State private var tabViewHieght: CGFloat = 0
        
        var body: some View {
            VStack {
                TabView(selection: $selectedIndex) {
                    ForEach(Onboarding.CarouselItem.allCases, id: \.self) { carouselItem in
                        VStack(spacing: 0) {
                            carouselItem.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 900, height: 200)

                            Text(carouselItem.title)
                                .font(.Main.semibold(size: 30))
                                .foregroundColor(.danubeBlue)
                                .padding(.top, 20)
                            
                            Text(carouselItem.subtitle)
                                .font(.Main.light(size: 16))
                                .foregroundColor(.oceanBlue)
                                .padding(.top, 6)
                        }
                        .tag(carouselItem.index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Spacer()
                HStack {
                    ForEach(0..<Onboarding.CarouselItem.allCases.count, id: \.self) { index in
                        let isSelected = (index == selectedIndex)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? Color.danubeBlue : Color.skyBlue.opacity(0.7))
                            .frame(width: isSelected ? 20 :  8, height: 8)
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
        ForEach(previewDevices) {
            Onboarding.CarouselView()
                .previewDevice($0)
                .previewDisplayName($0.rawValue)
        }
    }
}
#endif
