//
//  TestSliderViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class TestSliderViewController: UIViewController {
    
    var viewController: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .darkGray
        
        return view
    }()
    
    var sliderValueLabel: UILabel = {
        let label = UILabel()
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 1
//        label.layer.cornerRadius = 10
//        label.layer.masksToBounds = true
        label.numberOfLines = 0
//        label.backgroundColor = .black
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        
        return label
    }()
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.minimumValue = 0
        slider.maximumValue = 254
        slider.setValue(slider.maximumValue/2, animated: false)
        slider.addTarget(self, action: #selector(setSliderValue), for: .valueChanged)
        
        return slider
    }()
    
//    var cancelButton: UIButton = {
//        let button = UIButton()
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 8
//        button.backgroundColor = .white
//        button.setTitleColor(.black, for: .normal)
//        button.setTitleColor(.systemGray2, for: .highlighted)
//        button.setTitle("Cancel", for: .normal)
//        button.addTarget(self, action: #selector(onCancelButtonPressed), for: .touchUpInside)
//
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0, alpha: 0.0)
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
//        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewController.translatesAutoresizingMaskIntoConstraints = false
        self.sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewController.addSubview(self.slider)
//        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.viewController)
        self.viewController.addSubview(self.sliderValueLabel)
        
        self.sliderValueLabel.text = "\(String(Int(self.slider.value))) %"
        
        setConstraints()
        touchToRemoveFromSuperView()
    }
    
    func touchToRemoveFromSuperView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTouch))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func setSliderValue() {
        self.sliderValueLabel.text = "\(String(Int(self.slider.value))) %"
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.viewController.widthAnchor.constraint(equalToConstant: 206),
            self.viewController.heightAnchor.constraint(equalToConstant: 46),
            self.viewController.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.viewController.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.slider.widthAnchor.constraint(equalToConstant: 200),
            self.slider.heightAnchor.constraint(equalToConstant: 20),
            self.slider.centerXAnchor.constraint(equalTo: self.viewController.centerXAnchor),
            self.slider.bottomAnchor.constraint(equalTo: self.viewController.bottomAnchor, constant: -3)
        ])
        
        NSLayoutConstraint.activate([
            self.sliderValueLabel.widthAnchor.constraint(equalToConstant: 200),
            self.sliderValueLabel.heightAnchor.constraint(equalToConstant: 20),
            self.sliderValueLabel.centerXAnchor.constraint(equalTo: self.viewController.centerXAnchor),
            self.sliderValueLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -5)
        ])
        
//        NSLayoutConstraint.activate([
//            cancelButton.widthAnchor.constraint(equalToConstant: 100),
//            cancelButton.heightAnchor.constraint(equalToConstant: 40),
//            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
//            cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
//        ])
    }
    
    @objc func onViewTouch() {
        self.view.removeFromSuperview()
    }
}
