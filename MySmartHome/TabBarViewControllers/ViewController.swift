//
//  ViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var appNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .boldSystemFont(ofSize: 30)
        textLabel.textAlignment = .center
        textLabel.text = "My Smart Home"
        textLabel.textColor = .darkGray
        
        return textLabel
    }()
    
    var allDevicesButton: Button = {
        let button = Button()
        button.setTitle("Off", for: .normal)
        button.addTarget(self, action: #selector(allDevicesButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var addGroupButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.setTitle("Add group", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(addGroupButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var tableView = UITableView()
    
    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        allDevicesButton.translatesAutoresizingMaskIntoConstraints = false
        
        configureTableView()
        
        view.addSubview(tableView)
        view.addSubview(appNameLabel)
        view.addSubview(addGroupButton)
        view.addSubview(allDevicesButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.tableView.reloadData()
        })
        
        setupConstraints()
    }
    
    func configureTableView() {
        tableView.register(GroupButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        // tableView constraints
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        // appNameLabel constraints
        appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // addGroupButton constraints
        addGroupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addGroupButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addGroupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //allDevicesButton constraints
        allDevicesButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        allDevicesButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        allDevicesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        allDevicesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }
    
    @objc func addGroupButtonPressed() {
        showAddGroupDialog()
    }
    
    @objc func allDevicesButtonPressed() {
        turnLampOnOrOff(bool: !isOn)
    }
    
    func turnLampOnOrOff(bool: Bool) {
        isOn = bool
        
        //bool ? DeviceInfoOutput.turnOnDevice(id: "5449082") : DeviceInfoOutput.turnOffDevice(id: "5449082")
    }
}

// TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GetInfoAboutAllDevices.instance.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? GroupButtonTableViewCell else {
            fatalError("The deque cell is not an instace of GroupButtonTableViewCell.")
        }
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        if device?.type == "group" {
            cell.textLabel?.text = device?.name ?? "No group"
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let device = GetInfoAboutAllDevices.instance.devices[indexPath.row]
        
        if device.type == "group" {
            whenTableViewCellIsSelectedGoToNextView(title: device.name)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func whenTableViewCellIsSelectedGoToNextView(title: String) {
        let secondVC = DevicesInGroupViewController()
        secondVC.title = title
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

// Alert sign
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
            //            self.buttons.append(GroupButton(name: groupName))
            
            DeviceInfoOutput.instance.createNewDeviceGroupName(clientId: "", groupName: groupName, devices: "")
            
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in })
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}


