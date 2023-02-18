//
//  LoginView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import SwiftUI


struct Login {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: viewModel.onBack) {
                Text("welcome to the Login Page")
            }
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login.ContentView(viewModel: .init(onBack: { }))
    }
}
#endif
