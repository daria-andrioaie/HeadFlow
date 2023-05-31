//
//  FeedbackViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import Foundation

extension Feedback {
    class ViewModel: ObservableObject {
        @Published var inputText = ""
        @Published var isTyping = false
        let textViewModel: TextView.ViewModel

        init() {
            self.textViewModel = .init()
        }
        
        func sendFeedback() {
            guard !inputText.isEmpty else { return }
            
            inputText = ""
            textViewModel.clearText()
        }
    }
}
