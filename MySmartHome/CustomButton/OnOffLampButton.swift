//
//  OnOffLampButton.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("Off", for: .normal)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2
        layer.borderColor = Colors.twitterBlue.cgColor
        layer.cornerRadius = 25
        setTitleColor(Colors.twitterBlue, for: .normal)
        addTarget(self, action: #selector(Button.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        let color = bool ? Colors.twitterBlue : .clear
        let title = bool ? "On" : "Off"
        let titleColor = bool ? . white : Colors.twitterBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
}

struct Colors {
    static let twitterBlue = UIColor(displayP3Red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
}
