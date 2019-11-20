//
//  AllDevicesViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesViewController: UIViewController {
    
    var tableView: UITableView = {
        let tView = UITableView()
        tView.backgroundColor = .white
        
        return tView
    }()
    
    struct Cells {
        static let deviceCell = "DeviceCell"
    }
    
    private var deviceId: String = ""
    private var sliderValue: Float?
    
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        configureTableView()
        loadActivityIndicator()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeActivityIndicator()
        }
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: Cells.deviceCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
}

// TableView
extension AllDevicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GetInfoAboutAllDevices.instance.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.deviceCell) as? DeviceTableViewCell else {
            fatalError("The deque cell is not an instace of DeviceTableViewCell.")
        }
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        cell.setDeviceInfo(name: device?.name ?? "No name")
        cell.deviceId = device?.id ?? "No id"
        deviceId = device?.id ?? "No id"
        
        cell.deviceOnOrOffButton.isHidden = true
        cell.slider.isHidden = true
        
        DeviceInfoOutput.instance.getHistory(id: self.deviceId, onCompletion: {(state, stateValue) in
 
            
        })
        
        DeviceInfoOutput.instance.getDeviceInformation(id: device?.id ?? "", onCompletion: {(value, deviceType)  in

                if deviceType == TelldusKeys.dimmableDeviceNr {
                    cell.slider.isHidden = false
                    self.sliderValue = cell.slider.value
                    cell.setSlider(value: self.sliderValue ?? 0.0)
                   
                    
                } else {
                    cell.deviceOnOrOffButton.isHidden = false
                }
        })
        

        
        cell.backgroundColor = .white
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let device = GetInfoAboutAllDevices.instance.devices[indexPath.row]
        whenTableViewCellIsSelectedGoToNextView(title: device.name ?? "", id: device.id ?? "", deviceName: device.name ?? "", type: device.type ?? "")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // go to settingsViewController and send value
    func whenTableViewCellIsSelectedGoToNextView(title: String, id: String, deviceName: String, type: String) {
        let settings = SettingsViewController()
        settings.title = title
        settings.deviceName = deviceName
        settings.deviceId = id
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
//    @objc func buttonPressed(sender: Button) {
//        sender.isOn ? print("On") : print("Off")
//        sender.isOn ? lampButtonPressed(id: deviceId) : lampButtonPressed(id: deviceId)
//    }
//
//    func lampButtonPressed(id: String) {
//        print("print \(id)")
//    }
}

//// Show alert sign with settings
//extension AllDevicesViewController {
//
//    func showDialog(name: String, id : String) {
//            //Create the alert controller.
//            let alert = UIAlertController(title: "Settings", message: "Device: \(name)", preferredStyle: .alert)
//
//            // Change backgroundcolor to the alert sign
//    //        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
//    //        subview.backgroundColor = .gray
//
//            //Add the text field, with placeholder and sentence (Upper case) if user want to change name on the device.
//            alert.addTextField { (changeDeviceName) in
//                changeDeviceName.text = name
//                changeDeviceName.placeholder = "New device name"
//                changeDeviceName.autocapitalizationType = .sentences
//            }
//
//            // Show device id, user can't change id
//            alert.addTextField { (showDeviceId) in
//                showDeviceId.text = "Device id: \(id)"
//            }
//
//            //the confirm action taking the inputs
//            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (error) in
//
//                guard let deviceName = alert?.textFields?[0],
//                      let deviceId = alert?.textFields?[1] else {
//
//                    print("Issue with Alert TextFields \(error)")
//                    return
//                }
//                guard let newDeviceName = deviceName.text,
//                    let _ = deviceId.text else {
//
//                    print("Issue with TextFields Text \(error)")
//                    return
//                }
//
//                // Skicka data till telldus om användaren vill ändra namnet
//                print(newDeviceName)
//
//                DeviceInfoOutput.instance.setNewDeviceName(id: id, name: newDeviceName)
//            })
//
//            //the cancel action
//            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in })
//
//            //adding the actions to alertController
//            alert.addAction(acceptAction)
//            alert.addAction(cancelAction)
//
//            // Presenting the alert
//            self.present(alert, animated: true, completion: nil)
//        }
//}
