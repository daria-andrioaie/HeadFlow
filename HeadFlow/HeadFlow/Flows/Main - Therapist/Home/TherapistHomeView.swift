//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import SwiftUI

struct TherapistHome {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel

        var body: some View {
            VStack(spacing: 50) {
                Spacer()
                Text("You are a therapist. Welcome!")
                Spacer()
                profileButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .fillBackground()
        }
        
        var profileButton: some View {
            Button {
                viewModel.navigationAction(.goToProfile)
            } label: {
                Image(.userProfileFilled)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.3), radius: 20, x: 5, y: 5)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 40)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct TherapistHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistHome.ContentView(viewModel: .init(navigationAction: { _ in }))
    }
}
