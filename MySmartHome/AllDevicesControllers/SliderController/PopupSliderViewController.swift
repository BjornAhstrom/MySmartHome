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
        label.numberOfLines = 0
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
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(setSliderValue), for: .touchCancel)
        slider.addTarget(self, action: #selector(setSliderValueToLabel), for: .valueChanged)
        return slider
    }()
    
    var xAndYValueSlider = CGRect()
    var deviceId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0, alpha: 0.0)
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.viewController)
        self.view.addSubview(self.sliderValueLabel)
        self.view.addSubview(self.slider)
                
        setConstraints()
        touchToRemoveFromSuperView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setXAndYCoordinatesToViewController()
        getSliderValueFromTelldus()
    }
    
    func getSliderValueFromTelldus(){
        ApiManager.getHistory(id: deviceId, onCompletion: {(state, stateValue) in
            let value = Double(stateValue)/2.55
            
            self.sliderValueLabel.text = "\(String(Int(value))) %"
            self.slider.value = Float(stateValue)
        })
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
        let value = Int(self.slider.value)
        ApiManager.dimmableLamp(id: deviceId, dimValue: value)
    }
    
    @objc func setSliderValueToLabel() {
        let value = Double(self.slider.value/2.55)
        self.sliderValueLabel.text = "\(String(Int(value))) %"
    }
    
    func setConstraints() {
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
