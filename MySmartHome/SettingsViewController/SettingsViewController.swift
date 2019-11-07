//
//  SettingsViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-07.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var changeNameTextField: UITextField?
    var learnDeviceLabel: UILabel?
    var changeNameButton: UIButton?
    var learnDeviceButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureChangeTextField()
        configureChangeNameButton()
        configureLearnDeviceLabel()
        configureLearnDeviceButton()
        self.hideKeyBoard()
    }
    
    func configureChangeTextField() {
        changeNameTextField = UITextField()
        let text = changeNameTextField?.text
        
        changeNameTextField?.frame = CGRect(x: 12, y: 120, width: 200, height: 40)
        changeNameTextField?.placeholder = "New device name"
//        changeNameTextField?.layer.borderWidth = 1
//        changeNameTextField?.layer.borderColor = UIColor.darkGray.cgColor
//        changeNameTextField?.layer.cornerRadius = 20
        
        changeNameTextField?.borderStyle = UITextField.BorderStyle.roundedRect
        changeNameTextField?.keyboardType = UIKeyboardType.default
        changeNameTextField?.returnKeyType = UIReturnKeyType.done
        changeNameTextField?.clearButtonMode = UITextField.ViewMode.whileEditing
        changeNameTextField?.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        changeNameTextField?.delegate = self
        
        self.view.addSubview(changeNameTextField ?? UITextField())
        
        print(text ?? "")
        
//        let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
//        sampleTextField.placeholder = "Enter text here"
//        sampleTextField.font = UIFont.systemFont(ofSize: 15)
//        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
//        sampleTextField.keyboardType = UIKeyboardType.default
//        sampleTextField.returnKeyType = UIReturnKeyType.done
//        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
//        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        sampleTextField.delegate = self
//        self.view.addSubview(sampleTextField)
        
    }
    
    func configureChangeNameButton() {
        changeNameButton = UIButton()
        
        changeNameButton?.frame = CGRect(x: 240, y: 120, width: 120, height: 40)
        changeNameButton?.setTitleColor(.black, for: .normal)
        changeNameButton?.setTitleColor(.systemGray2, for: .highlighted)
        changeNameButton?.setTitle("Change name", for: .normal)
        changeNameButton?.layer.borderWidth = 1
        changeNameButton?.layer.borderColor = UIColor.darkGray.cgColor
        changeNameButton?.layer.cornerRadius = 20
        changeNameButton?.addTarget(self, action: #selector(changeNameButtonPressed), for: .touchUpInside)
        
        view.addSubview(changeNameButton ?? UIButton())
    }
    
    @objc func changeNameButtonPressed() {
        print(changeNameTextField?.text ?? "No text")
        changeNameTextField?.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == changeNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func configureLearnDeviceLabel() {
        learnDeviceLabel = UILabel()
        learnDeviceLabel?.frame = CGRect(x: 12, y: 180, width: 200, height: 40)
        learnDeviceLabel?.text = "Learn Device"
        learnDeviceLabel?.font = UIFont(name: "Arial", size: 20)
        learnDeviceLabel?.textColor = UIColor.black
        
        view.addSubview(learnDeviceLabel ?? UILabel())
    }
    
    func configureLearnDeviceButton() {
        learnDeviceButton = UIButton()
        
        learnDeviceButton?.frame = CGRect(x: 240, y: 180, width: 120, height: 40)
        learnDeviceButton?.setTitleColor(.black, for: .normal)
        learnDeviceButton?.setTitleColor(.systemGray2, for: .highlighted)
        learnDeviceButton?.setTitle("Learn", for: .normal)
        learnDeviceButton?.layer.borderWidth = 1
        learnDeviceButton?.layer.borderColor = UIColor.black.cgColor
        learnDeviceButton?.layer.cornerRadius = 20
        learnDeviceButton?.addTarget(self, action: #selector(learnDeviceButtonPressed), for: .touchUpInside)
        
        view.addSubview(learnDeviceButton ?? UIButton())
        
    }
    
    @objc func learnDeviceButtonPressed() {
        print("Learn device")
    }
    
}
