//
//  ViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var allDevicesButton: Button?
    var addGroupButton: UIButton?
    var settingsButton: UIButton?
    var image: UIImageView?
    var label: UILabel?
    
    var tableView = UITableView()
    
    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appNameLabel()
        configureAllDevicesButton()
        configureAddGroupButton()
        configureTableView()
    }
    
    func appNameLabel() {
        label = UILabel()
        label?.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 50)
        
        label?.text = "My Smart Home"
        label?.textAlignment = NSTextAlignment.center
        label?.numberOfLines = 2
        label?.textColor = UIColor.darkGray
//        label?.backgroundColor = UIColor.darkGray
        label?.font = UIFont.boldSystemFont(ofSize: 20.0)
        label?.font = UIFont(name: "Arial", size: 30)
         
        self.view.addSubview(label ?? UILabel())
    }
    
    func configureAllDevicesButton() {
        allDevicesButton = Button()
        allDevicesButton?.setTitle("Off", for: .normal)
//        allDevicesButton?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        
        allDevicesButton?.addTarget(self, action: #selector(allDevicesButtonPressed), for: .touchUpInside)
        
        view.addSubview(allDevicesButton ?? Button())
        setButtonConstraints()
    }
    
    func setButtonConstraints() {
            allDevicesButton?.translatesAutoresizingMaskIntoConstraints = false
            allDevicesButton?.heightAnchor.constraint(equalToConstant: 80).isActive = true
            allDevicesButton?.widthAnchor.constraint(equalToConstant: 200).isActive = true
    //        allDevicesButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            allDevicesButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            allDevicesButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        setConstraintsToTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func configureAddGroupButton() {
        addGroupButton = UIButton()
        addGroupButton?.setTitle("Add group", for: .normal)
        addGroupButton?.setTitleColor(.darkGray, for: .normal)
        addGroupButton?.layer.borderColor = UIColor.darkGray.cgColor
        addGroupButton?.layer.borderWidth = 1
        addGroupButton?.layer.cornerRadius = 25
        
        addGroupButton?.addTarget(self, action: #selector(addGroupButtonPressed), for: .touchUpInside)
        view.addSubview(addGroupButton ?? UIButton())
        setConstraintsOnAddGroupButton()
    }
    
    func setConstraintsOnAddGroupButton() {
        addGroupButton?.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addGroupButton?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addGroupButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addGroupButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setConstraintsToTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    @objc func addGroupButtonPressed() {
        print("Add group")
        showAddGroupDialog()
    }
    
    @objc func allDevicesButtonPressed() {
        turnLampOnOrOff(bool: !isOn)
    }
    
    func turnLampOnOrOff(bool: Bool) {
        isOn = bool
        
//        bool ? DeviceInfoOutput.turnOnDevice(id: "5449082") : DeviceInfoOutput.turnOffDevice(id: "5449082")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

extension ViewController {
    
    func showAddGroupDialog() {
        
        let alert = UIAlertController(title: "Add group", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(addGroupName) in
            addGroupName.placeholder = "Group name"
            addGroupName.autocapitalizationType = .sentences
        })
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (error) in
            guard let newGroupName = alert?.textFields?[0] else {
                print(" \(error)")
                return
            }
            guard let groupName = newGroupName.text else {
                print(" \(error)")
                return
            }
            
            // Tillsätt namnet till den nyskapade knappen
            print(groupName)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {(_) in })
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
}
