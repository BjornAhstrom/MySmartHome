//
//  GroupCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    var textLabel: UILabel = {
       let label = UILabel()
//        label.layer.borderColor = UIColor.darkGray.cgColor
//        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(imageView)
        addSubview(textLabel)
        
        setConstraints()
        
//        textLabelAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextAndImageToCell(name: String) {
        textLabel.text = name
    }
    
    func setConstraints() {
         // imageView constraints
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
        
        // texLabel constraints
        NSLayoutConstraint.activate([
            textLabel.heightAnchor.constraint(equalToConstant: 20),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    func textLabelAnimation() {

        DispatchQueue.main.async(execute: {

            UIView.animate(withDuration: 10.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in

                self.textLabel.center = CGPoint(x: 0 - self.textLabel.bounds.size.width / 2, y: self.textLabel.center.y)

            }, completion:  nil)
        })
    }
}
