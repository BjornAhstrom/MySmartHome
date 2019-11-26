//
//  ScenariosCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ScenariosCollectionViewCell: UICollectionViewCell {
    
    var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        
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
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.deviceNameLabel.heightAnchor.constraint(equalToConstant: 40),
            self.deviceNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.deviceNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.deviceNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
}
