//
//  GroupButtonTableViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GroupButtonTableViewCell: UITableViewCell {

    let groupButtonLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTextLabel()
//        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextToLabel(name: String) {
        groupButtonLabel.text = name
    }
    
    func configureTextLabel() {
        groupButtonLabel.numberOfLines = 0
        groupButtonLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setTitleLabelConstraints() {
        groupButtonLabel.translatesAutoresizingMaskIntoConstraints = false
//        groupButtonLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        groupButtonLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        groupButtonLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        groupButtonLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}
