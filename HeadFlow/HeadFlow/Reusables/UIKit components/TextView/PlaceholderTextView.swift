//
//  PlaceholderTextView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import Foundation
import UIKit

@IBDesignable
class PlaceholderTextView: UITextView {
    
    @IBInspectable var placeholder: String = ""
    @IBInspectable var placeholderColor: UIColor = UIColor.gray
    @IBInspectable var placeholderFont: UIFont = UIFont.systemFont(ofSize: 12)
    @IBInspectable var textInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 9, right: 8)
    
    private let uiPlaceholderTextChangedAnimationDuration: Double = 0.05
    private let defaultTagValue = 999
    
    var placeHolderLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupInsets()
    }
    
    func setupInsets() {
        textContainerInset = textInsets
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    @objc func textChanged() {
        guard !placeholder.isEmpty else { return }
        
        UIView.animate(withDuration: uiPlaceholderTextChangedAnimationDuration) {
            if self.text.isEmpty {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(0.8)
            }
            else {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(0.0)
            }
        }
    }
    
    override var text: String! {
        didSet{
            super.text = text
            textChanged()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard !placeholder.isEmpty else {
            super.draw(rect)
            return
        }
        
        if placeHolderLabel == nil {
            placeHolderLabel = UILabel(
                frame: CGRect(
                    x: textInsets.left + 4,
                    y: textInsets.top,
                    width: bounds.size.width - textInsets.left - textInsets.right - 4,
                    height: 0
                )
            )
            
            placeHolderLabel!.lineBreakMode = .byWordWrapping
            placeHolderLabel!.numberOfLines = 0
            placeHolderLabel!.font = placeholderFont
            placeHolderLabel!.backgroundColor = UIColor.clear
            placeHolderLabel!.textColor = placeholderColor
            placeHolderLabel!.alpha = 0
            placeHolderLabel!.tag = defaultTagValue
            
            self.addSubview(placeHolderLabel!)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2.5
        
        let attrString = NSAttributedString(
            string: placeholder,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: placeholderFont,
                .foregroundColor: placeholderColor
            ]
        )
        
        placeHolderLabel!.attributedText = attrString
        placeHolderLabel!.sizeToFit()
        
        self.sendSubviewToBack(placeHolderLabel!)
        
        if text.isEmpty && !placeholder.isEmpty {
            viewWithTag(defaultTagValue)?.alpha = 1.0
        }
        
        super.draw(rect)
    }
}
