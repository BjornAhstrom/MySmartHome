//
//  PopupSliderViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class PopupSliderViewController: UIViewController {
    
    var viewController: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .init(white: 0.3, alpha: 0.7)
        
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
        slider.maximumValue = 100
        slider.setValue(slider.maximumValue/2, animated: false)
        slider.addTarget(self, action: #selector(setSliderValue), for: .valueChanged)
        
        return slider
    }()
    
    var xAndYValueSlider = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0, alpha: 0.0)
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
//        self.viewController.translatesAutoresizingMaskIntoConstraints = false
        self.sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.viewController)
        self.view.addSubview(self.sliderValueLabel)
        self.view.addSubview(self.slider)
                
        self.sliderValueLabel.text = "\(String(Int(self.slider.value))) %"
        
        setConstraints()
        touchToRemoveFromSuperView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setXAndYCoordinatesToViewController()
    }
    
    func setXAndYCoordinatesToViewController() {
        viewController.frame = CGRect(x: xAndYValueSlider.origin.x, y: xAndYValueSlider.origin.y+130, width: 206, height: 46)

        if viewController.frame.maxX >= self.view.frame.maxX {
            viewController.frame = CGRect(x: xAndYValueSlider.origin.x-30, y: xAndYValueSlider.origin.y+130, width: 206, height: 46)
        }
        else if viewController.frame.minX <= self.view.frame.minX {
            viewController.frame = CGRect(x: xAndYValueSlider.origin.x+30, y: xAndYValueSlider.origin.y+130, width: 206, height: 46)
        }
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
//        NSLayoutConstraint.activate([
//            self.viewController.widthAnchor.constraint(equalToConstant: 206),
//            self.viewController.heightAnchor.constraint(equalToConstant: 46),
//            self.viewController.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: xAndYValueSlider.origin.y),
//            self.viewController.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: xAndYValueSlider.origin.x*0.20)
//        ])
        
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
    }
    
    @objc func onViewTouch() {
        self.view.removeFromSuperview()
    }
}
