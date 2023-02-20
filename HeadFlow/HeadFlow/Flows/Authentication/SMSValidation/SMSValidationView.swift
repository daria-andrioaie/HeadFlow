//
//  SMSValidationView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import SwiftUI

struct SMSValidation {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: {
                viewModel.onNavigation?(.goBack)
            }) {
                VStack {
                    Text("here you will enter the code")
                }
                .padding(.horizontal, 24)
            }
            .onTapGesture(perform: hideKeyboard)
        }
    }
}


struct SMSValidationView_Previews: PreviewProvider {
    static var previews: some View {
        SMSValidation.ContentView(viewModel: .init())
    }
}
