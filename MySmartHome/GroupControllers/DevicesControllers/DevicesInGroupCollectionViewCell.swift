//
//  DevicesInGroupCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DevicesInGroupCollectionViewCell: UICollectionViewCell {
    
//    var cellImage: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
//        image.layer.borderWidth = 1
//        image.layer.borderColor = UIColor.black.cgColor
//        image.layer.cornerRadius = 10
//
//        return image
//    }()
    
    var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
//        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        cellImage.translatesAutoresizingMaskIntoConstraints = false
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(cellImage)
        addSubview(deviceNameLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDeviceNameToLabel(name: String) {
        deviceNameLabel.text = name
//        cellImage.image = image
    }
    
    func setConstraints() {
//        NSLayoutConstraint.activate([
//            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            deviceNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            deviceNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deviceNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
