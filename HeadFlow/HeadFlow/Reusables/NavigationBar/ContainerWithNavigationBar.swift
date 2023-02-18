//
//  ContainerWithNavigationBar.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct ContainerWithNavigationBar<Content: View>: View {
    let title: String?
    let leftButtonAction: () -> Void
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            NavigationBar(title: title, leftButtonAction: leftButtonAction)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fillBackground()
    }
}

#if DEBUG
struct ContainerWithNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ContainerWithNavigationBar(title: "navbar title", leftButtonAction: { }) {
            Text("hello world")
        }
    }
}
#endif
