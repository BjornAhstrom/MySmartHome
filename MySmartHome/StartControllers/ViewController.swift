//
//  ViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate {
    
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
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(allDevicesButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var settingButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.setTitle("S", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(settingsButtonForAllDevicesButtonPressed), for: .touchUpInside)
        
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
    
    let deviceIdKey = "DeviceId"
    
    var tableView = UITableView()
    var isOn = false
    var deviceId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        allDevicesButton.translatesAutoresizingMaskIntoConstraints = false
        
        configureTableView()
        
        view.addSubview(tableView)
        view.addSubview(appNameLabel)
        view.addSubview(addGroupButton)
        view.addSubview(allDevicesButton)
        view.addSubview(settingButton)
        
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addGroupButton.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // appNameLabel constraints
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 110),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appNameLabel.bottomAnchor.constraint(equalTo: allDevicesButton.topAnchor, constant: -20)
        ])
        
        // allDevicesButton constraints
        NSLayoutConstraint.activate([
            allDevicesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allDevicesButton.heightAnchor.constraint(equalToConstant: 80),
            allDevicesButton.widthAnchor.constraint(equalToConstant: 200),
            allDevicesButton.bottomAnchor.constraint(equalTo: addGroupButton.topAnchor, constant: -30)
        ])
        
        // addGroupButton constraints
        NSLayoutConstraint.activate([
            addGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addGroupButton.heightAnchor.constraint(equalToConstant: 50),
            addGroupButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // settingsButton
        NSLayoutConstraint.activate([
            settingButton.topAnchor.constraint(equalTo: allDevicesButton.topAnchor, constant: 5),
            settingButton.trailingAnchor.constraint(equalTo: allDevicesButton.trailingAnchor, constant: -5),
            settingButton.widthAnchor.constraint(equalToConstant: 30),
            settingButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func setValue() {
        deviceId =  UserDefaults.standard.string(forKey: deviceIdKey) ?? ""
    }
    
    @objc func settingsButtonForAllDevicesButtonPressed() {
        print("Settings button pressed")
        
        let popup = ButtonSettingsViewController()
        self.addChild(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
    
    @objc func addGroupButtonPressed() {
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.title = "Add new group"
        self.navigationController?.pushViewController(addGroupViewController, animated: true)
    }
    
    @objc func allDevicesButtonPressed() {
        setValue()
        turnLampOnOrOff(bool: !isOn)
    }
    
    func turnLampOnOrOff(bool: Bool) {
        isOn = bool
        
        print("AllDevicesButton id: \(deviceId)")
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

        cell.setTextToLabel(name: device?.name ?? "No group")
        
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        whenTableViewCellIsSelectedGoToNextView(groupName: device?.name ?? "No name", id: device?.id ?? "No id", devicesId: device?.devices ?? "No devices")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func whenTableViewCellIsSelectedGoToNextView(groupName: String, id: String, devicesId: String) {
        let groupViewController = DevicesInGroupViewController()
        groupViewController.title = groupName
        groupViewController.groupId = id
        groupViewController.devicesId = devicesId
        self.navigationController?.pushViewController(groupViewController, animated: true)
    }
}


