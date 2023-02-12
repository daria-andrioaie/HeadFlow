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
            Text("welcome to the Login Page")
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login.ContentView(viewModel: .init())
    }
}
