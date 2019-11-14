//
//  ButtonSettingsViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-14.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ButtonSettingsViewController: UIViewController {
    
    var viewController: UIView = {
        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        view.layer.cornerRadius = 15
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    var okButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitle("Ok", for: .normal)
        button.addTarget(self, action: #selector(onOkButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(onCancelButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewController)
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            viewController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewController.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.widthAnchor.constraint(equalToConstant: 300),
            viewController.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancelButton.trailingAnchor),
            okButton.trailingAnchor.constraint(equalTo: viewController.trailingAnchor, constant: -10),
            okButton.bottomAnchor.constraint(equalTo: viewController.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: viewController.leadingAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: viewController.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func onCancelButtonPressed() {
        print("Pressed")
        self.view.removeFromSuperview()
    }
    
    @objc func onOkButtonPressed() {
        print("Pressed")
        
    }
    
}
