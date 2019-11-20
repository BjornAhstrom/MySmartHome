//
//  AllDevicesCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesCollectionViewCell: UICollectionViewCell {
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.minimumValue = 0
        slider.maximumValue = 254
        slider.setValue(slider.maximumValue/2, animated: false)
        
        return slider
    }()
    
    var imageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                imageView.image = UIImage(named: "LampOn")
            } else {
                imageView.image = UIImage(named: "LampOff")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        slider.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(slider)
        addSubview(imageView)
        addSubview(textLabel)
        
        setConstraints(sliderIsOn: false)
        
        //        textLabelAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSliderValue(value: Float) {
        slider.value = value
    }
    
    func setTextAndImageToCell(name: String, image: UIImage) {
        textLabel.text = name
        imageView.image = image
    }
    
    func setConstraints(sliderIsOn: Bool) {
        // slider constraints
        slider.widthAnchor.constraint(equalToConstant: contentView.frame.width/2).isActive = sliderIsOn
        slider.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = sliderIsOn
        slider.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = sliderIsOn
        slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = sliderIsOn
        slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = sliderIsOn
        
        // imageView constraints
        imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        imageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
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
