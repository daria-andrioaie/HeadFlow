//
//  BasicExerciseCard.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import SwiftUI

struct BasicExerciseCard: View {
    @State private var isAdded: Bool = false
    var exercise: StretchingExercise
    var onAdd: () -> Void
    
    var body: some View {
        VStack {
            summaryView
        }
        .padding(15)
        .frame(height: 100)
        .background(Color.diamond.cornerRadius(15))
    }
    
    var summaryView: some View {
        Button {
            isAdded.toggle()
            onAdd()
        } label: {
            HStack( spacing: 15) {
                exerciseImageView
                
                Text(exercise.type.title)
                    .font(.Main.medium(size: 20))
                    .foregroundColor(.oceanBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Buttons.Checkbox(isChecked: $isAdded)
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
            .frame(height: 100)
        }
        .opacity(isAdded ? 1 : 0.7)
        .buttonStyle(.plain)
    }
    
    var exerciseImageView: some View {
        Image(exercise.type.image)
            .resizable()
            .scaledToFit()
            .frame(width: 50)
            .padding(10)
            .background(Color.white.cornerRadius(15))
    }
}

struct BasicExerciseCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                BasicExerciseCard(exercise: .mock1, onAdd: { })
            }
            .padding(.horizontal, 30)
        }
    }
}
