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
    
//    var buttons: [GroupButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        buttons = mockData()
        
        appNameLabel()
        configureAllDevicesButton()
        configureAddGroupButton()
        configureTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.tableView.reloadData()
        })
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
        tableView.register(GroupButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        setConstraintsToTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureAddGroupButton() {
        addGroupButton = UIButton()
        addGroupButton?.setTitle("Add group", for: .normal)
        addGroupButton?.setTitleColor(.darkGray, for: .normal)
        addGroupButton?.layer.borderColor = UIColor.darkGray.cgColor
        addGroupButton?.setTitleColor(.systemGray2, for: .highlighted)
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

// Mockdata
extension ViewController {
    
    func mockData() -> [GroupButton] {
        let button1 = GroupButton(name: "Sovrumet")
        let button2 = GroupButton(name: "Vardagsrummet")
        let button3 = GroupButton(name: "Hallen")
        
        return [button1, button2, button3]
        
    }
}
