//
//  CustomAlert.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.03.2023.
//

import SwiftUI

struct CustomAlert: View {
    let alert: Alert
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            VStack(spacing: 12) {
                Text(alert.title)
                    .font(.Main.semibold(size: 20))
    
                Text(alert.message)
                    .font(.Main.regular(size: 18))
                    .padding(.horizontal, 8)
                
                Divider()
                
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.Main.regular(size: 18))
                    }
                    .frame(maxWidth: .infinity)

                    Divider()
                        .frame(height: 30)

                
                    Button {
                        alert.action()
                        isPresented = false
                    } label: {
                        Text(alert.actionButtonMessage)
                            .font(.Main.medium(size: 18))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.all)
            .background(RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.diamond))
            .padding(.horizontal, 50)
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top).combined(with: .opacity).animation(.linear(duration: 0.3))))
            .zIndex(1)
            
        }
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(alert: .init(title: "Alert!!", message: "This is the message of the alert", actionButtonMessage: "Take action!", action: { }), isPresented: .constant(true))
    }
}
