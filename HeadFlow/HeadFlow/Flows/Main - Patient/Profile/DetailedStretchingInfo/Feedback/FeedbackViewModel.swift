//
//  FeedbackViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import Foundation

extension Feedback {
    class ViewModel: ObservableObject {
        @Published var isFeedbackLoading: Bool = false
        @Published var inputText = ""
        @Published var isTyping = false
        @Published var feedback: Feedback.Model? = nil
        
        let sessionId: String
        let feedbackService: FeedbackServiceProtocol
        let textViewModel: TextView.ViewModel
        
        private var getFeebackTask: Task<Void, Error>?
        private var sendFeebackTask: Task<Void, Error>?


        init(sessionId: String, feedbackService: FeedbackServiceProtocol) {
            self.textViewModel = .init()
            self.sessionId = sessionId
            self.feedbackService = feedbackService
            
            getFeedback()
        }
        
        func getFeedback() {
            getFeebackTask?.cancel()
            isFeedbackLoading = true
            
            getFeebackTask = Task { @MainActor in
                await feedbackService.getFeedbackForSession(with: sessionId, onRequestCompleted: { result in
                    switch result {
                    case .success(let feedback):
                        self.feedback = feedback
                    case .failure(let failure):
                        print(failure.message)
                    }
                    self.isFeedbackLoading = false
                })
            }
        }
        
        func sendFeedback() {
            guard !inputText.isEmpty else { return }
            
            sendFeebackTask?.cancel()
            isFeedbackLoading = true
            
            getFeebackTask = Task { @MainActor in
                await feedbackService.sendFeedbackForSession(with: sessionId, message: inputText, onRequestCompleted: { result in
                    switch result {
                    case .success(let feedback):
                        DispatchQueue.main.async {
                            self.feedback = feedback
                            self.inputText = ""
                            self.textViewModel.clearText()
                        }
                    case .failure(let failure):
                        print(failure.message)
                    }
                    
                    self.isFeedbackLoading = false
                })
            }
        }
    }
}
