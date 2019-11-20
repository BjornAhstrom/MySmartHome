//
//  DeviceTableViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .green
        slider.minimumValue = 0
        slider.maximumValue = 254
        slider.setValue(slider.maximumValue/2, animated: false)
        
        return slider
    }()

    var deviceTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        
        return label
    }()
    
    var deviceOnOrOffButton: Button = {
        let button = Button()
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Off", for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var deviceId: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        deviceTitle.translatesAutoresizingMaskIntoConstraints = false
        deviceOnOrOffButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(slider)
        addSubview(deviceTitle)
        addSubview(deviceOnOrOffButton)
        
        setConstraints()
    }
    
    func setDeviceInfo(name: String) {
        deviceTitle.text = name
    }
    
    func setSlider(value: Float) {
        slider.value = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        // slider constraints
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalToConstant: 70),
            slider.heightAnchor.constraint(equalToConstant: 40),
            slider.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            slider.leadingAnchor.constraint(equalTo: deviceTitle.trailingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
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
