//
//  SettingsViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-07.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var learnDeviceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Arial", size: 20)
        label.text = "Learn device"
        
        return label
    }()
    
    var changeNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.placeholder = "New device name"
        
        
        return textField
    }()
    
    var learnDeviceButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 20
        button.setTitle("Learn", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(learnDeviceButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var changeNameButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 20
        button.setTitle("Change name", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(changeNameButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var deviceName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        changeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        learnDeviceButton.translatesAutoresizingMaskIntoConstraints = false
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        learnDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(learnDeviceLabel)
        view.addSubview(changeNameButton)
        view.addSubview(learnDeviceButton)
        view.addSubview(changeNameTextField)
        
        self.hideKeyBoard()
        
        changeNameTextField.text = deviceName
        
        setConstraints()
    }
    
    func setConstraints() {
        // changeNameTextField constraints
        changeNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        changeNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        changeNameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changeNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // changeNameButton constraints
        changeNameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        changeNameTextField.leadingAnchor.constraint(equalTo: changeNameTextField.trailingAnchor, constant: 20).isActive = true
        changeNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        changeNameButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        changeNameButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // learnDeviceLabel constraints
        learnDeviceLabel.topAnchor.constraint(equalTo: changeNameTextField.bottomAnchor, constant: 10).isActive = true
        learnDeviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        learnDeviceLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        learnDeviceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // learnDeviceButton
        learnDeviceButton.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor, constant: 10).isActive = true
        learnDeviceButton.leadingAnchor.constraint(equalTo: learnDeviceLabel.trailingAnchor, constant: 20).isActive = true
        learnDeviceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        learnDeviceButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        learnDeviceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func changeNameButtonPressed() {
        print(changeNameTextField.text ?? "error")
        changeNameTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == changeNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func learnDeviceButtonPressed() {
        print("Learn device")
    }
    
}
