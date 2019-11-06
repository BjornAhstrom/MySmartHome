//
//  AllDevicesViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesViewController: UIViewController {

    var tableView = UITableView()
    
    struct Cells {
        static let deviceCell = "DeviceCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        DevicesInput.getDevicesInfo(url: "https://api.telldus.com/json/devices/list")
        tableView.reloadData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: Cells.deviceCell)
        constraintsForTheTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func constraintsForTheTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AllDevicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DevicesInput.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.deviceCell) as? DeviceTableViewCell else {
            fatalError("The deque cell is not an instace of DeviceTableViewCell.")
        }
        let device = DevicesInput.devices[indexPath.row]
        
        cell.setDeviceInfo(name: device.name)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
//        cell.layer.cornerRadius = 15
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 1
//        cell.layer.shadowOffset = .zero
//        cell.layer.shadowRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let device = DevicesInput.devices[indexPath.row]
        
        showDialog(name: device.name, id: device.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension AllDevicesViewController {
    
    func showDialog(name: String, id : String) {
            //Create the alert controller.
            let alert = UIAlertController(title: "Settings", message: "Device: \(name)", preferredStyle: .alert)
            
            // Change backgroundcolor to the alert sign
    //        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
    //        subview.backgroundColor = .gray
            
            //Add the text field, with placeholder and sentence (Upper case) if user want to change name on the device.
            alert.addTextField { (changeDeviceName) in
                changeDeviceName.text = name
                changeDeviceName.placeholder = "New device name"
                changeDeviceName.autocapitalizationType = .sentences
            }
            
            // Show device id, user can't change id
            alert.addTextField { (showDeviceId) in
                showDeviceId.text = "Device id: \(id)"
            }
            
            //the confirm action taking the inputs
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (error) in
                
                guard let deviceName = alert?.textFields?[0],
                      let deviceId = alert?.textFields?[1] else {
                        
                    print("Issue with Alert TextFields \(error)")
                    return
                }
                guard let newDeviceName = deviceName.text,
                    let _ = deviceId.text else {
                        
                    print("Issue with TextFields Text \(error)")
                    return
                }

                // Skicka data till telldus om användaren vill ändra namnet
                print(newDeviceName)
            })
            
            //the cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in })
            
            //adding the actions to alertController
            alert.addAction(acceptAction)
            alert.addAction(cancelAction)
            
            // Presenting the alert
            self.present(alert, animated: true, completion: nil)
        }
}
