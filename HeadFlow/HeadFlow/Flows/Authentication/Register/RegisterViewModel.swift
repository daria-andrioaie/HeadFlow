//
//  RegisterViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import Foundation
import SwiftUI

extension Register {
    class ViewModel: ObservableObject {
        var onBack: () -> Void
        
        init(onBack: @escaping () -> Void) {
            self.onBack = onBack
        }
    }
}
