//
//  FeedbackInputView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import Foundation
import SwiftUI

extension Feedback {
    struct InputView: View {
        
        @ObservedObject var viewModel: ViewModel
        
        @State private var textViewHeight: CGFloat = 46
        
        var body: some View {
            textView
                .overlay(
                    sendButton
                        .padding(.trailing, 10),
                    alignment: .bottomTrailing
                )
                .frame(maxWidth: .infinity)
        }
        
        private var textView: some View {
            TextView(
                text: $viewModel.inputText,
                textViewHeight: $textViewHeight,
                isTyping: $viewModel.isTyping,
                viewModel: viewModel.textViewModel
            ) { textView in
                textView.backgroundColor = .clear
                textView.textContainerInset = .zero
                textView.showsVerticalScrollIndicator = false
                
                textView.textColor = UIColor(.oceanBlue)
                textView.font = UIFont(name: MainFontName.regular.rawValue, size: 18)!
                textView.placeholder = "Leave some feedback.."
                textView.placeholderColor = UIColor(.oceanBlue.opacity(0.5))
                textView.placeholderFont = UIFont(name: MainFontName.regular.rawValue, size: 16)!
            }
            .frame(height: textViewHeight)
            .padding(.leading, 8)
            .padding(.trailing, 50)
            .background(
                Color.diamond
                    .roundedCorners([.topRight, .topLeft, .bottomLeft], radius: 15)
            )
        }
        
        private var sendButton: some View {
            Button {
                viewModel.sendFeedback()
            } label: {
                Image(systemName: "paperplane.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.danubeBlue)
                    .clipped()
            }
            .frame(width: 36, height: 36)
            .opacity(viewModel.inputText.isEmpty ? 0.6 : 1)
            .disabled(viewModel.inputText.isEmpty)
            .buttonStyle(.plain)
        }
    }
}

#if DEBUG
struct FeedbackInputView_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(previewDevices) {
            VStack(spacing: 0) {
                Color.black.opacity(0.7)
                Feedback.InputView(viewModel: .init(sessionId: "random",
                                                    feedbackService: MockFeedbackService()))
            }
            .edgesIgnoringSafeArea(.all)
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
#endif
