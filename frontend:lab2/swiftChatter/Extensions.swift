//
//  Extensions.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/30/22.
//

import UIKit

extension UILabel {
    convenience init(useMask: Bool, font: UIFont = UIFont.systemFont(ofSize: 17.0), fontSize: CGFloat = 17.0, text: String? = nil, lines: Int = 0, linebreak: NSLineBreakMode = .byWordWrapping) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = useMask
        self.font = font.withSize(fontSize)
        self.text = text
        numberOfLines = lines
        lineBreakMode = linebreak
    }
    
    func highlight(searchedText: String?..., color: UIColor = .systemBlue) {
            guard let txtLabel = self.text else { return }
            let attributeTxt = NSMutableAttributedString(string: txtLabel)
            searchedText.forEach {
                if let searchedText = $0?.lowercased() {
                    let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)
                    attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                    attributeTxt.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: self.font.pointSize), range: range)
                }
            }
            self.attributedText = attributeTxt
    }
}

extension UITextView {
    convenience init(useMask: Bool, font: UIFont = UIFont.systemFont(ofSize: 17.0), text: String? = nil) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = useMask
        self.font = font
        self.text = text
    }
}


