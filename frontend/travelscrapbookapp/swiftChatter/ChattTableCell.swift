//
//  ChattTableCell.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/9/22.
//

import UIKit

final class ChattTableCell: UITableViewCell {
    
    let usernameLabel = UILabel(useMask: false)
    let timestampLabel = UILabel(useMask: false)
    let messageLabel = UILabel(useMask: false)
    let geodataLabel = UILabel(useMask: false, fontSize: 12.0)
    var mapButton: UIButton!
    var renderChatt: (() -> Void)?
    
    required init?(coder: NSCoder) {
           fatalError("ChattTableCell: does not support unarchiving view from xib/nib files")
       }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           contentView.addSubview(usernameLabel)
           contentView.addSubview(timestampLabel)
           contentView.addSubview(messageLabel)
            contentView.addSubview(geodataLabel)

           let lmg = contentView.layoutMarginsGuide
            mapButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in self.renderChatt?() }))
            mapButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
            mapButton.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(mapButton)
        
            NSLayoutConstraint.activate([
                    usernameLabel.topAnchor.constraint(equalTo: lmg.topAnchor),
                    usernameLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                    
                    timestampLabel.topAnchor.constraint(equalTo: lmg.topAnchor),
                    timestampLabel.trailingAnchor.constraint(equalTo: lmg.trailingAnchor),
                    
                    messageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
                    messageLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                    messageLabel.widthAnchor.constraint(equalTo: lmg.widthAnchor),
                    geodataLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
                    geodataLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                    geodataLabel.widthAnchor.constraint(equalTo: lmg.widthAnchor),
                    lmg.bottomAnchor.constraint(equalTo: geodataLabel.bottomAnchor),
                    mapButton.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 10),
                    mapButton.trailingAnchor.constraint(equalTo: lmg.trailingAnchor, constant: -8),
                    //lmg.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor)
                   
                ])
       }
    
}
