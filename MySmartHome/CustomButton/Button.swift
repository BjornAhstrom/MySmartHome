//
//  Button.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    var isOn = false
    var deviceId: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.getStateFromDevice()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("Off", for: .normal)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 15
        setTitleColor(UIColor.darkGray, for: .normal)
        addTarget(self, action: #selector(Button.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        bool ? lampIsOn() : lampIsOff()
//        let color = bool ? UIColor.darkGray : .clear
        let title = bool ? "On" : "Off"
//        let titleColor = bool ? .white : UIColor.darkGray
        
        bool ? DeviceInfoOutput.instance.turnOnDevice(id: self.deviceId) : DeviceInfoOutput.instance.turnOffDevice(id: self.deviceId)
        
//        setTitle(title, for: .normal)
//        setTitleColor(titleColor, for: .normal)
//        backgroundColor = color
    }
    
    func getStateFromDevice() {
        
//        isOn ? DeviceInfoOutput.instance.turnOffDevice(id: deviceId) : DeviceInfoOutput.instance.turnOnDevice(id: deviceId)
        
        DeviceInfoOutput.instance.getHistory(id: deviceId, onCompletion: {(state, stateValue) in
            if state == 1 {
                self.isOn = true
//                self.setTitleColor(.white, for: .normal)
//                self.backgroundColor = .darkGray
                self.lampIsOn()
                self.setTitle("On", for: .normal)
                
            }
            else if state == 2 {
                self.isOn = false
//                self.setTitleColor(.darkGray, for: .normal)
//                self.backgroundColor = .clear
                self.lampIsOff()
                self.setTitle("Off", for: .normal)
                
            }
        })
    }
    
    func lampIsOn() {
        self.setTitleColor(Colors.lightningWhiteColor, for: .normal)
        self.setTitle("On", for: .normal)
        self.backgroundColor = .init(white: 0.7, alpha: 0.4)
        self.layer.borderColor = Colors.lightningWhiteColor.cgColor
        self.layer.borderWidth = 5
        
        self.layer.shadowColor = Colors.lightningWhiteColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
    }
    
    func lampIsOff() {
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitle("Off", for: .normal)
        self.backgroundColor = .init(white: 0.3, alpha: 0.4)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 5
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0
    }
}



struct Colors {
    static let lightningWhiteColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
    static let lightningBlue = UIColor(displayP3Red: 143/255, green: 184/255, blue: 255/255, alpha: 0.7)
    static let lightningLightBlue = UIColor(displayP3Red: 174/255, green: 234/255, blue: 255/255, alpha: 0.7)
}
