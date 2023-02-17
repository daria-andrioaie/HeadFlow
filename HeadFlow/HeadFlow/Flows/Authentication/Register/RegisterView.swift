//
//  RegisterView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct Register {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: "Register", leftAction: viewModel.onBack) {
                Text("welcome to the Register Page")
            }
        }
    }
}

#if DEBUG
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Register.ContentView(viewModel: .init(onBack: { }))
    }
}
#endif
