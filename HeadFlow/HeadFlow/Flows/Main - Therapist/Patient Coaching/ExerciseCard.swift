//
//  ExerciseCard.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.05.2023.
//

import SwiftUI

struct ExerciseCard: View {
    @State private var isExpanded: Bool = false
    @State private var durationIndex = 0
    @State private var range: Double = 0.0
    @State private var rotationDegree = -90.0
    @State private var alertIsShowing = false
    
    let exerciseType: StretchType
    @Binding var offset: CGSize
    let onDelete: () -> Void
    
    private let items: [PickerItem] = (0...30).map { PickerItem(value: $0)}
    
    var body: some View {
        VStack {
            summaryView
                .swipeLeftGesture(offset: $offset, canSwipe: !isExpanded) {
                    onDelete()
                }
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
//        Button {
//            withAnimation(.easeInOut(duration: 0.2)) {
//                isExpanded.toggle()
//            }
//        } label: {
            HStack(alignment: .top, spacing: 15) {
                exerciseImageView
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(exerciseType.title)
                        .font(.Main.medium(size: 20))
                        .foregroundColor(.oceanBlue)
                    exerciseParameters
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Image(systemName: "chevron.down")
                    .opacity(0.5)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .contentShape(Rectangle())
            .frame(height: 100)
//        }
//        .buttonStyle(.plain)
    }
    
    var settingsView: some View {
        VStack {
            rangeSliderView
            durationWheelPickerView
        }
        .transition(.opacity.combined(with: .scale))
    }
    
    var rangeSliderView: some View {
        HStack {
            Slider(value: $range, in: 0...Double(exerciseType.maximumDegrees), step: 1) {
                Text("range")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("\(exerciseType.maximumDegrees)°")
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
    struct StatefulListOfExercises: View {
        @State private var offset: CGSize = .zero
        
        var body: some View {
            ScrollView {
                VStack {
                    ExerciseCard(exerciseType: .rotateToLeft, offset: $offset, onDelete: { })
                    ExerciseCard(exerciseType: .tiltForward, offset: $offset, onDelete: { })
                    ExerciseCard(exerciseType: .tiltBackwards, offset: $offset, onDelete: { })
                    ExerciseCard(exerciseType: .tiltToRight, offset: $offset, onDelete: { })

                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    static var previews: some View {
        StatefulListOfExercises()
    }
}
