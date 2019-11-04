//
//  DeviceTableViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    var deviceTitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(deviceTitle)
        
        configureTitleLabel()
        setTitleLabelConstraints()
    }
    
    func setDeviceInfo(name: String) {
        deviceTitle.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitleLabel() {
        deviceTitle.numberOfLines = 0
        deviceTitle.adjustsFontSizeToFitWidth = true
    }
    
    func setTitleLabelConstraints() {
        deviceTitle.translatesAutoresizingMaskIntoConstraints = false
        deviceTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        deviceTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        deviceTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true
        deviceTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
