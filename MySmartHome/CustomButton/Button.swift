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
    var timer: DispatchSourceTimer?
    var stateValue: Int = 0
    var deviceType: String = ""
    var st: Int = 0
    var devices: [Deviceinfo] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
        
        //        DispatchQueue.main.async {
        self.getStateFromDevice()
        
        //        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("\(NSLocalizedString("setTitleOff", comment: ""))", for: .normal)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 15
        setTitleColor(UIColor.darkGray, for: .normal)
        lampIsOff()
        addTarget(self, action: #selector(Button.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        bool ? lampIsOn() : lampIsOff()
        bool ? ApiManager.turnOnDevice(id: self.deviceId) : ApiManager.turnOffDevice(id: self.deviceId)
    }
    
    // MARK: Get on and off history from an device
    func getStateFromDevice() {
        
        let queue = DispatchQueue.global(qos: .background)
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer?.schedule(deadline: .now(), repeating: .milliseconds(2000), leeway: .seconds(1))
        self.timer?.setEventHandler(handler: {
            
            ApiManager.getHistory(id: self.deviceId, onCompletion: {(state, stateValue) in
                
                self.setStateOnButton(state: state, stateValue: stateValue)
            })
        })
        self.timer?.resume()
    }
    
    func setStateOnButton(state: Int, stateValue: Int) {
        
        if self.st != state { // Kolla om det här fungerar
//            print("self.st: \(self.st), state: \(state)")
            self.st = state
            
            if self.st == 1 && self.st != 0 || self.stateValue > 0 {
                DispatchQueue.main.async {
                    self.isOn = true
                    self.lampIsOn()
                    self.setTitle("\(NSLocalizedString("setTitleOn", comment: ""))", for: .normal)
                }
            }
            else if self.st == 2 && self.st != 0 || self.stateValue <= 0 {
                DispatchQueue.main.async {
                    self.isOn = false
                    self.lampIsOff()
                    self.setTitle("\(NSLocalizedString("setTitleOn", comment: ""))", for: .normal)
                }
            }
            
        }
        
        
        //        print("state: \(state), stateValue: \(stateValue)")
    }
    
    func lampIsOn() {
        DispatchQueue.main.async {
            self.setTitleColor(ButtonColors.lightningWhiteColor, for: .normal)
            self.setTitle("\(NSLocalizedString("setTitleOn", comment: ""))", for: .normal)
            self.backgroundColor = .init(white: 0.7, alpha: 0.4)
            self.layer.borderColor = ButtonColors.lightningWhiteColor.cgColor
            self.layer.borderWidth = 5
            
            self.layer.shadowColor = ButtonColors.lightningWhiteColor.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 15
        }
    }
    
    func lampIsOff() {
        DispatchQueue.main.async {
            self.setTitleColor(.gray, for: .normal)
            self.setTitle("\(NSLocalizedString("setTitleOff", comment: ""))", for: .normal)
            self.backgroundColor = .init(white: 0.3, alpha: 0.4)
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.borderWidth = 5
            
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0
        }
    }
}

struct ButtonColors {
    static let lightningWhiteColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
    static let lightningBlue = UIColor(displayP3Red: 143/255, green: 184/255, blue: 255/255, alpha: 0.7)
    static let lightningLightBlue = UIColor(displayP3Red: 174/255, green: 234/255, blue: 255/255, alpha: 0.7)
}
