//
//  ThirdViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    var tableView = UITableView()
    
    struct Cells {
        static let deviceCell = "DeviceCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        DevicesInput.getDevicesInfo(tableView: tableView, url: "https://api.telldus.com/json/devices/list")
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: Cells.deviceCell)
        constraintsForTheTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func constraintsForTheTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DevicesInput.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.deviceCell) as! DeviceTableViewCell
        let device = DevicesInput.devices[indexPath.row]
        
        cell.setDeviceInfo(name: device.name)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
