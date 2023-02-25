//
//  AuthenticationCompleteView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI

struct AuthenticationCompleteView: View {
    @State private var showMessage: Bool = false
    var afterAppear: () -> Void
    
    var body: some View {
        ZStack {
            Color.danubeBlue
            if showMessage {
                VStack(spacing: 45) {
                    AnimatedCheckmarkView()
                    Text("All done and ready to go!")
                        .foregroundColor(.feathers)
                        .font(.Main.medium(size: 26))
                }
                .transition(AnyTransition.opacity.animation(.easeIn(duration: 1)))
                .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            showMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    afterAppear()
                }
            }
    }
}

struct AuthenticationCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationCompleteView(afterAppear: { })
    }
}
