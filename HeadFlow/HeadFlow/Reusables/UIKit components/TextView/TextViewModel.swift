//
//  TextViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import Foundation
import SwiftUI

extension TextView {
    
    class ViewModel: ObservableObject {
        
        weak var textView: PlaceholderTextView?
        weak var coordinator: Coordinator?
        
        func clearText() {
            guard let textView = textView else { return }
            textView.text = ""
            coordinator?.configureForNewText(textView)
        }
    }
}
