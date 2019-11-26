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
        textField.backgroundColor = UIColor.white
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .left
        textField.textColor = .darkGray
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
    var newDeviceName: String = ""
    var deviceId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        changeNameTextField.text = deviceName
        
        changeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        learnDeviceButton.translatesAutoresizingMaskIntoConstraints = false
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        learnDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(learnDeviceLabel)
        view.addSubview(changeNameButton)
        view.addSubview(learnDeviceButton)
        view.addSubview(changeNameTextField)
        
        self.hideKeyBoard()
        
        setConstraints()
    }
    
    func setConstraints() {
        // changeNameTextField constraints
        NSLayoutConstraint.activate([
            changeNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            changeNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            changeNameTextField.trailingAnchor.constraint(lessThanOrEqualTo: changeNameButton.leadingAnchor, constant: -12),
            changeNameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            changeNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // changeNameButton constraints
        NSLayoutConstraint.activate([
            changeNameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            changeNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            changeNameButton.widthAnchor.constraint(equalToConstant: 120),
            changeNameButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // learnDeviceLabel constraints
        NSLayoutConstraint.activate([
            learnDeviceLabel.topAnchor.constraint(equalTo: changeNameTextField.bottomAnchor, constant: 10),
            learnDeviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            learnDeviceLabel.trailingAnchor.constraint(lessThanOrEqualTo: learnDeviceButton.leadingAnchor, constant: -12),
            learnDeviceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            learnDeviceLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // learnDeviceButton
        NSLayoutConstraint.activate([
            learnDeviceButton.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor, constant: 10),
            learnDeviceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            learnDeviceButton.widthAnchor.constraint(equalToConstant: 120),
            learnDeviceButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func changeNameButtonPressed() {
        newDeviceName = changeNameTextField.text ?? ""
        
        ApiManager.setNewDeviceName(id: deviceId, name: newDeviceName)
        
        changeNameTextField.text = newDeviceName
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
