//
//  ExerciseCard.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.05.2023.
//

import SwiftUI

struct ExerciseCard: View {
    @State private var isExpanded: Bool = false
    
    let exerciseType: StretchType
    @State private var durationIndex = 0
    @State private var range: Double = 0.0
    @State private var rotationDegree = -90.0
    let items: [PickerItem] = (0...30).map { PickerItem(value: $0)}
    
    var body: some View {
        VStack {
            summaryView
                .zIndex(1)
            
            if isExpanded {
                settingsView
            }
        }
        .padding(15)
        .frame(height: isExpanded ? 250 : 100, alignment: .top)
        .background(Color.diamond.cornerRadius(15))
    }
    
    var summaryView: some View {
        HStack(alignment: .top, spacing: 15) {
            exerciseImageView
            
            VStack(alignment: .leading, spacing: 15) {
                Text(exerciseType.title)
                    .font(.Main.medium(size: 20))
                    .foregroundColor(.oceanBlue)
                exerciseParameters
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "chevron.down")
                    .opacity(0.5)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .buttonStyle(.plain)
        }
        .frame(height: 100)
    }
    
    var settingsView: some View {
        VStack {
            rangeSliderView
            durationWheelPickerView
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    var rangeSliderView: some View {
        HStack {
            Slider(value: $range, in: 0...Double(exerciseType.totalRangeOfMotion), step: 1) {
                Text("range")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("\(exerciseType.totalRangeOfMotion)°")
            }
            .introspectSlider { uiSlider in
                uiSlider.thumbTintColor = UIColor(Color.oceanBlue.opacity(0.7))
                uiSlider.tintColor = UIColor(Color.danubeBlue)
            }
            .font(.Main.regular(size: 20))
        }
    }
    
    var durationWheelPickerView: some View {
        ZStack(alignment: .bottom) {
            WheelPicker(chosenIndex: $durationIndex, rotationDegree: $rotationDegree, items: items, circleSize: 300)
                .frame(height: 80, alignment: .top)
                .clipped()
            Text("duration")
                .font(.Main.light(size: 20))
                .padding(10)
        }
    }
    
    var exerciseImageView: some View {
        Image(exerciseType.image)
            .resizable()
            .scaledToFit()
            .frame(width: 50)
            .padding(10)
            .background(Color.white.cornerRadius(15))
    }
    
    var exerciseParameters: some View {
        HStack(spacing: 20) {
            HStack {
                Image(systemName: "clock")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(.oceanBlue.opacity(0.5))
                Text("\(items[durationIndex].value) sec")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 18))
                    .opacity(0.5)
            }
            
            Text("max \(range.formatted())°")
                .foregroundColor(.oceanBlue)
                .font(.Main.regular(size: 18))
                .opacity(0.5)
        }
    }
}

struct ExerciseCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ExerciseCard(exerciseType: .rotateToLeft)
                ExerciseCard(exerciseType: .tiltForward)
                ExerciseCard(exerciseType: .tiltBackwards)
                ExerciseCard(exerciseType: .tiltToRight)

            }
            .padding(.horizontal, 30)
        }
    }
}
