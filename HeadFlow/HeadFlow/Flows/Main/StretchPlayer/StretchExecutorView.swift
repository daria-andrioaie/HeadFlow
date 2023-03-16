//
//  StretchExecutorView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import SwiftUI

struct StretchExecutor {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                Button {
                    viewModel.navigationAction?(.goBack)
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
                .font(.Main.medium(size: 18))
                .padding(.leading, 30)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                Text("Execute stretch")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
        }
    }
}


struct StretchExecutorView_Previews: PreviewProvider {
    static var previews: some View {
        StretchExecutor.ContentView(viewModel: .init())
    }
}
