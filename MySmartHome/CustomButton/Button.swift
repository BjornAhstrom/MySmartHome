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
        
        let color = bool ? UIColor.darkGray : .clear
        let title = bool ? "On" : "Off"
        let titleColor = bool ? .white : UIColor.darkGray
        
        bool ? DeviceInfoOutput.instance.turnOnDevice(id: self.deviceId) : DeviceInfoOutput.instance.turnOffDevice(id: self.deviceId)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
    func getStateFromDevice() {
        
//        isOn ? DeviceInfoOutput.instance.turnOffDevice(id: deviceId) : DeviceInfoOutput.instance.turnOnDevice(id: deviceId)
        
        DeviceInfoOutput.instance.getHistory(id: deviceId, onCompletion: {(state, stateValue) in
            if state == 1 {
                self.isOn = true
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = .darkGray
                self.setTitle("On", for: .normal)
                
            }
            else if state == 2 {
                self.isOn = false
                self.setTitleColor(.darkGray, for: .normal)
                self.backgroundColor = .clear
                self.setTitle("Off", for: .normal)
                
            }
        })
    }
}



//struct Colors {
//    static let twitterBlue = UIColor(displayP3Red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
//}
