//
//  NavigationBar.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct NavigationBar: View {
    let title: String
    let leftAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                leftAction()
            } label: {
                Text("back")
            }
            Spacer()
            Text(title)
            
        }
        .frame(height: 48)
        .background(Color.apricot)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "navbar title", leftAction: { })
    }
}
