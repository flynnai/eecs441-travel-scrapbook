//
//  PostView.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/30/22.
//

import UIKit

class PostView: UIView {

    let usernameLabel = UILabel(useMask: false, text: "YOUR_UNIQNAME")
    let messageTextView = UITextView(useMask: false, text: "Some sample short text")
    
    required init?(coder: NSCoder) {
            fatalError("PostView: does not support unarchiving view from xib/nib files")
        }
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            self.backgroundColor = .systemBackground
            
            addSubview(usernameLabel)
            addSubview(messageTextView)

            let lmg = layoutMarginsGuide
            NSLayoutConstraint.activate([
                usernameLabel.topAnchor.constraint(equalTo: lmg.topAnchor, constant: 20),
                usernameLabel.centerXAnchor.constraint(equalTo: lmg.centerXAnchor),

                messageTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
                messageTextView.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                messageTextView.widthAnchor.constraint(equalTo: lmg.widthAnchor),
                
                bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 10)
            ])
        }

}
