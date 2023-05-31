//
//  TextView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = PlaceholderTextView
    
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    @Binding var isTyping: Bool

    let maxHeight: CGFloat = 90
    
    var maxNoOfCharacters = -1
    var shouldBecomeFirstResponder = false
    var viewModel: ViewModel

    var configuration = { (view: UIViewType) in }
    
    
    func makeUIView(context: Context) -> UIViewType {
        let view = PlaceholderTextView()
        viewModel.textView = view
        view.delegate = context.coordinator
        
        let endPosition: UITextPosition = view.endOfDocument
        view.selectedTextRange = view.textRange(from: endPosition, to: endPosition)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        configuration(uiView)
        uiView.text = text
        
        if shouldBecomeFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        viewModel.coordinator = coordinator
        return coordinator
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView //TODO: weak
        var maxNoOfCharacters = -1
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isTyping = false
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            configureForNewText(textView)
        }
        
        func configureForNewText(_ textView: UITextView) {
            parent.textViewHeight = min(textView.contentSize.height, parent.maxHeight)
            parent.isTyping = textView.text.count > 0
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard parent.maxNoOfCharacters > 0 else { return true }
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            
            return numberOfChars <= parent.maxNoOfCharacters
        }
    }
}
