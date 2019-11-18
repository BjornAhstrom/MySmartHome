//
//  DeviceTableViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    var deviceTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var deviceOnOrOffButton: Button = {
        let button = Button()
        button.setTitle("Off", for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var deviceId: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deviceTitle.translatesAutoresizingMaskIntoConstraints = false
        deviceOnOrOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(deviceTitle)
        addSubview(deviceOnOrOffButton)
        
        setConstraints()
        
    }
    
    func setDeviceInfo(name: String) {
        deviceTitle.text = name
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func lampButtonPressed(id: String) {
        
    }
    
    func setConstraints() {
        // deviceTitle constraints
        NSLayoutConstraint.activate([
            deviceTitle.topAnchor.constraint(equalTo: topAnchor),
            deviceTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            deviceTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // deviceOnOrOffButton constraints
        NSLayoutConstraint.activate([
            deviceOnOrOffButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            deviceOnOrOffButton.widthAnchor.constraint(equalToConstant: 70),
            deviceOnOrOffButton.heightAnchor.constraint(equalToConstant: 40),
            deviceOnOrOffButton.leadingAnchor.constraint(equalTo: deviceTitle.trailingAnchor, constant: 20),
            deviceOnOrOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            deviceOnOrOffButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
