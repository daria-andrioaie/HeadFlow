//
//  CustomAlert.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.03.2023.
//

import SwiftUI

struct CustomAlert<IconView: View, CancelView: View, ActionView: View>: View {
    let alert: Alert
    @Binding var isPresented: Bool
    
    @ViewBuilder var iconView: IconView
    @ViewBuilder var cancelView: CancelView
    @ViewBuilder var actionView: ActionView
    
    @State private var isIconShaking: Bool = false
    
    var body: some View {
        if isPresented {
            VStack(spacing: 30) {
                cancelView
                    .padding(.leading, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                alertInfo
                
                Divider()
                
                actionView
                    .offset(y: -6)
            }
            .padding(.all)
            .background(Color.white)
            .cornerRadius(30)
            .padding(.horizontal, 45)
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top).combined(with: .opacity).animation(.linear(duration: 0.3))))
            .zIndex(1)
            .onAppear {
                isIconShaking.toggle()
            }
        }
    }
    
    var alertInfo: some View {
        VStack(spacing: 18) {
            iconView
                .rotationEffect(.degrees(isIconShaking ? 0 : 10))
                .animation(.easeInOut(duration: 0.2).repeatCount(7), value: isIconShaking)
            
            Text(alert.title)
                .font(.Main.medium(size: 20))
            
            Text(alert.message)
                .multilineTextAlignment(.center)
                .font(.Main.regular(size: 18))
                .padding(.horizontal, 8)
        }
    }
}

#if DEBUG
struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            ZStack {
                Color.feathers
                CustomAlert(alert: .init(title: "Alert!!", message: "This is the message of the alert"), isPresented: .constant(true), iconView: {
                    Image(.bell)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.apricot)
                        .frame(width: 50)
                }, cancelView: {
                    Button {
                        
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.Main.light(size: 16))
                    }
                }, actionView: {
                    Button {
                        
                    } label: {
                        Text("Go to settings")
                            .foregroundColor(.oceanBlue)
                            .font(.Main.regular(size: 20))
                    }
                })
            }
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
#endif
