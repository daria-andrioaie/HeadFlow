//
//  HomeView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI

struct Home {
    struct ContentView: View {
        var body: some View {
            Text("Welcome to home screen")
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home.ContentView()
    }
}
#endif
