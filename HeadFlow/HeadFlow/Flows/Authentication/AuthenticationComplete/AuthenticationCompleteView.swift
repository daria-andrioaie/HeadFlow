//
//  AuthenticationCompleteView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import SwiftUI

struct AuthenticationCompleteView: View {
    var afterAppear: () -> Void
    
    var body: some View {
        Text("All done")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    afterAppear()
                }
            }
    }
}

struct AuthenticationCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationCompleteView(afterAppear: { })
    }
}
