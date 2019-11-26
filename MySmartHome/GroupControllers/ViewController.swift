//
//  ViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate {
    
    var backgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Background")
        
        return view
    }()
    
    var appNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .boldSystemFont(ofSize: 30)
        textLabel.textAlignment = .center
        textLabel.text = "My Smart Home"
        textLabel.textColor = .darkGray
        
        return textLabel
    }()
    
        var allDevicesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Off", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(allDevicesButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
        var settingButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.setTitle("•••", for: .normal)
        button.addTarget(self, action: #selector(settingsButtonForAllDevicesButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var addGroupButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 25
        button.backgroundColor = .init(white: 0.3, alpha: 0.7)
        button.setTitle("Add group", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(addGroupButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var tableView: UITableView = {
        let tView = UITableView()
        tView.backgroundColor = .init(white: 0.3, alpha: 0.7)
        tView.layer.cornerRadius = 8
        tView.layer.masksToBounds = true
        tView.register(GroupButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        
        return tView
    }()
    
    let deviceIdKey = "DeviceId"
    let activityIndicator = UIActivityIndicatorView()
    let lightningColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)//UIColor(displayP3Red: 143/255, green: 184/255, blue: 255/255, alpha: 0.7)//UIColor(displayP3Red: 174/255, green: 234/255, blue: 255/255, alpha: 0.7)
    
    var isOn = false
    var groupId: String?
    var test: Int = 0
    var devicesIds: [String] = [] // split string from deviceId in to this array
    var groups = [Deviceinfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        allDevicesButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(appNameLabel)
        view.addSubview(addGroupButton)
        view.addSubview(allDevicesButton)
        view.addSubview(settingButton)
        
        setupConstraints()
        setGroupIdValue()
        lampIsOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getDeviceInfo()
        
        DispatchQueue.main.async {
            self.getGroupApiRequest()
        }
        
        DispatchQueue.main.async {
            
        }
    }
    
    // MARK:  Group api request
    func getGroupApiRequest() {
        groups = []
        self.startActivityIndicator(activityIndicator: activityIndicator)
        
        ApiManager.getAlldevicesRequest(onCompletion: { response in
            
            for group in response.device ?? [] {
                
                if group.type ?? "" == "group" {
                    self.groups.append(group)
                }
            }
            self.tableView.reloadData()
            self.stopActivityIndicator(activityIndicator: self.activityIndicator)
        })
    }
    
    // MARK: Get device history to set lamp buttons on or off
    func getDeviceInfo() {
        self.startActivityIndicator(activityIndicator: activityIndicator)
        
        ApiManager.getGroupDevicesId(id: groupId ?? "No id", onCompletion: {(response) in
            
            // Strängen som kommer från responsen är en sträng med flera id som är komma (,) separerade ex (12345,54321,34567)
            // Här tas komma tecknet bort och separerar alla id och lägger dem i en String array
            self.devicesIds = response.components(separatedBy: ",")
            
            for id in self.devicesIds {
                ApiManager.getHistory(id: id, onCompletion: {(state, stateValue)  in
                    
                    DispatchQueue.main.async {
                        if state == 1 {
                            self.isOn = true
                            self.lampIsOn()
                        }
                        else if state == 2 {
                            self.isOn = false
                            self.lampIsOff()
                            
                        }
                        self.tableView.reloadData()
                    }
                })
            }
            
        })
        
        self.stopActivityIndicator(activityIndicator: self.activityIndicator)
    }
    
    @objc func settingsButtonForAllDevicesButtonPressed() {
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
        setGroupIdValue()
        turnLampOnOrOff(bool: !isOn)
    }
    
    func turnLampOnOrOff(bool: Bool) {
        isOn = bool
        bool ? self.lampIsOn() : self.lampIsOff()
        bool ? allDevicesButton.setTitle("On", for: .normal) : allDevicesButton.setTitle("Off", for: .normal)
        bool ? ApiManager.turnOnDevice(id: groupId ?? "No id") : ApiManager.turnOffDevice(id: groupId ?? "No id")
    }
    
    // MARK: lampIsOn: change alldevices button to light layout
    func lampIsOn() {
        self.allDevicesButton.setTitleColor(self.lightningColor, for: .normal)
        self.allDevicesButton.setTitle("On", for: .normal)
        self.allDevicesButton.backgroundColor = .init(white: 0.7, alpha: 0.4)
        self.allDevicesButton.layer.borderColor = self.lightningColor.cgColor
        self.allDevicesButton.layer.borderWidth = 5
        
        self.allDevicesButton.layer.shadowColor = self.lightningColor.cgColor
        self.allDevicesButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.allDevicesButton.layer.shadowOpacity = 1
        self.allDevicesButton.layer.shadowRadius = 15
        
        // Change settingbutton when lamps is on
        self.settingButton.layer.borderColor = self.lightningColor.cgColor
        self.settingButton.setTitleColor(self.lightningColor, for: .normal)
        self.settingButton.backgroundColor = .init(white: 0.0, alpha: 0.0)
    }
    
    // MARK: lampIsOff: change alldevices button to dark layout
    func lampIsOff() {
        self.allDevicesButton.setTitleColor(.gray, for: .normal)
        self.allDevicesButton.setTitle("Off", for: .normal)
        self.allDevicesButton.backgroundColor = .init(white: 0.3, alpha: 0.7)
        self.allDevicesButton.layer.borderColor = UIColor.gray.cgColor
        self.allDevicesButton.layer.borderWidth = 5
        
        self.allDevicesButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.allDevicesButton.layer.shadowOpacity = 0
        
        // Change settingButton when lamps is off
        self.settingButton.layer.borderColor = UIColor.gray.cgColor
        self.settingButton.setTitleColor(.gray, for: .normal)
        self.settingButton.backgroundColor = .init(white: 0.0, alpha: 0.0)
    }
    
    public func setGroupIdValue() {
        groupId =  UserDefaults.standard.string(forKey: deviceIdKey) ?? ""
    }
    
    func setupConstraints() {
        // backgroundView constraints
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
            settingButton.topAnchor.constraint(equalTo: allDevicesButton.topAnchor, constant: 10),
            settingButton.trailingAnchor.constraint(equalTo: allDevicesButton.trailingAnchor, constant: -10),
            settingButton.widthAnchor.constraint(equalToConstant: 30),
            settingButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

// MARK: TableView for groups
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count   //GetInfoAboutAllDevices.instance.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? GroupButtonTableViewCell else {
            fatalError("The deque cell is not an instace of GroupButtonTableViewCell.")
        }
        
        cell.backgroundColor = .init(white: 0, alpha: 0)
        
        let group = self.groups[indexPath.row]
        
        cell.groupOnOrOffButton.deviceId = group.id ?? ""
        cell.setTextToLabel(name: group.name ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
//        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        let group = self.groups[indexPath.row]
        
        whenTableViewCellIsSelectedGoToNextView(groupName: group.name ?? "No name", id: group.id ?? "No id", devicesId: group.devices ?? "No devices")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func whenTableViewCellIsSelectedGoToNextView(groupName: String, id: String, devicesId: String) {
                
        let groupViewController = DevicesInGroupViewController()
        groupViewController.title = groupName
        groupViewController.groupName = groupName
        groupViewController.groupId = id
        groupViewController.devicesId = devicesId
        self.navigationController?.pushViewController(groupViewController, animated: true)
    }
}


