//
//  GroupButtonTableViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GroupButtonTableViewCell: UITableViewCell {

    var groupDevicesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var groupOnOrOffButton: Button = {
        let button = Button()
        button.setTitle("Off", for: .normal)
//        button.setTitleColor(.darkGray, for: .normal)
//        button.setTitleColor(.systemGray2, for: .highlighted)
//        button.layer.borderColor = UIColor.darkGray.cgColor
//        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    var isOn: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        groupDevicesLabel.translatesAutoresizingMaskIntoConstraints = false
        groupOnOrOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(groupDevicesLabel)
        addSubview(groupOnOrOffButton)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextToLabel(name: String) {
        groupDevicesLabel.text = name
    }
    
    func setConstraints() {
        // groupDevicesLabel constraints
        NSLayoutConstraint.activate([
            groupDevicesLabel.topAnchor.constraint(equalTo: topAnchor),
            groupDevicesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            groupDevicesLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        // groupOnOrOffButton constraints
        NSLayoutConstraint.activate([
            groupOnOrOffButton.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 10),
            groupOnOrOffButton.leadingAnchor.constraint(lessThanOrEqualTo: groupDevicesLabel.trailingAnchor, constant: 20),
            groupOnOrOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            groupOnOrOffButton.widthAnchor.constraint(equalToConstant: 70),
            groupOnOrOffButton.heightAnchor.constraint(equalToConstant: 40),
            groupOnOrOffButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
    
}
