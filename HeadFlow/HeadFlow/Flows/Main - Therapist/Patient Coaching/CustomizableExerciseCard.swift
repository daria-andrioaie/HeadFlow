//
//  ExerciseCard.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.05.2023.
//

import SwiftUI

struct CustomizableExerciseCard: View {
    @State private var isExpanded: Bool = false
    @State private var rotationDegree = -90.0
    @State private var alertIsShowing = false
    
    @Binding var exercise: StretchingExercise
    let isEditing: Bool
    var onDelete: (() -> Void)? = nil
    
    private let items: [PickerItem] = (0...30).map { PickerItem(value: $0)}
    
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
        Button {
            if isEditing {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }
        } label: {
            HStack(alignment: .top, spacing: 15) {
                exerciseImageView
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(exercise.type.title)
                        .font(.Main.medium(size: 20))
                        .foregroundColor(.oceanBlue)
                    exerciseParameters
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                if isEditing {
                    VStack {
                        Image(systemName: "chevron.down")
                            .opacity(0.5)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        
                        Button {
                            onDelete?()
                        } label: {
                            Image(systemName: "trash")
                                .renderingMode(.template)
                                .foregroundColor(.red)
                        }
                        .padding(.top, 20)
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentShape(Rectangle())
            .frame(height: 100)
        }
        .buttonStyle(.plain)
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
            Slider(value: .init(get: {
                return Double(exercise.goalDegrees)
            }, set: { newValue in
                exercise.goalDegrees = Int(newValue)
            }), in: 0...Double(exercise.maximumDegrees), step: 1) {
                Text("range")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("\(exercise.maximumDegrees)°")
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
            WheelPicker(chosenIndex: .init(get: {
                items.firstIndex(where: { $0.value == exercise.duration }) ?? 0
            }, set: { newIndex in
                exercise.duration = items[newIndex].value
            }), items: items, circleSize: 300)
                .frame(height: 80, alignment: .top)
                .clipped()
            Text("duration")
                .font(.Main.light(size: 20))
                .padding(10)
        }
    }
    
    var exerciseImageView: some View {
        Image(exercise.type.image)
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
                Text("\(exercise.duration) sec")
                    .foregroundColor(.oceanBlue)
                    .font(.Main.regular(size: 18))
                    .opacity(0.5)
            }
            
            Text("max \(exercise.goalDegrees.formatted())°")
                .foregroundColor(.oceanBlue)
                .font(.Main.regular(size: 18))
                .opacity(0.5)
        }
    }
}

struct CustomizableExerciseCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                CustomizableExerciseCard(exercise: .constant(.mock1), isEditing: false)
            }
            .padding(.horizontal, 30)
        }
    }
}
