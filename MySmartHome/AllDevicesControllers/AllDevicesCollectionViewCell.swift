//
//  AllDevicesCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesCollectionViewCell: UICollectionViewCell {
    
    lazy var uiView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0, alpha: 0)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var sliderButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        //        button.setImage(UIImage(named: "Slider"), for: .normal)
        //        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var onOffButton: Button = {
        let button = Button()
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var imageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = .white
        
        return label
    }()
    
//    override var isSelected: Bool {
//        didSet {
//            if self.isSelected {
//                imageView.image = UIImage(named: "LampOn")
//            } else {
//                imageView.image = UIImage(named: "LampOff")
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sliderButton.translatesAutoresizingMaskIntoConstraints = false
        onOffButton.translatesAutoresizingMaskIntoConstraints = false
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sliderButton)
        addSubview(onOffButton)
//        addSubview(imageView)
        uiView.addSubview(textLabel)
        addSubview(uiView)
        
        setConstraints(sliderIsOn: false)
//        slideTexToLeft()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextAndImageToCell(name: String) {  //, image: UIImage) {
        textLabel.text = name
//        imageView.image = image
    }
    
    func setConstraints(sliderIsOn: Bool) {
        // uiView constraints
        NSLayoutConstraint.activate([
            uiView.heightAnchor.constraint(equalToConstant: 20),
            uiView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor),
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // texLabel constraints
        NSLayoutConstraint.activate([
            textLabel.heightAnchor.constraint(equalToConstant: 20),
            textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
        
        // sliderButton constraints
        sliderButton.widthAnchor.constraint(equalToConstant: contentView.frame.width/2).isActive = sliderIsOn
        sliderButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = sliderIsOn
        sliderButton.leadingAnchor.constraint(equalTo: onOffButton.trailingAnchor, constant: 5).isActive = sliderIsOn
        sliderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = sliderIsOn
        sliderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = sliderIsOn
        
        // onOffButton constraints
        NSLayoutConstraint.activate([
            onOffButton.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.width/3), //.isActive = true
            onOffButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5), //.isActive = true
            onOffButton.centerXAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor), //.isActive = true
            onOffButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5) //.isActive = true
        ])
        
        
        // imageView constraints
//        imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
//        imageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    func slideTexToLeft(duration: Double, delay: Double) {
//        DispatchQueue.main.async(execute: {

            UIView.animate(withDuration: duration, delay: delay, options: ([.curveLinear, .repeat]), animations: {() -> Void in

                self.textLabel.transform = CGAffineTransform(translationX: self.textLabel.bounds.origin.x - 200, y: self.textLabel.bounds.origin.y)

            }, completion:  nil)
//        })
    }
}
