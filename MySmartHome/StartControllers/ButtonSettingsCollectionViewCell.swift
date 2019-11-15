//
//  ButtonSettingsCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-15.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ButtonSettingsCollectionViewCell: UICollectionViewCell {
    
    var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(deviceNameLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNameToLabel(name: String) {
        deviceNameLabel.text = name
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            deviceNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            deviceNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            deviceNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deviceNameLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
