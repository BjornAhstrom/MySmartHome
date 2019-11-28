////
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
        view.layer.cornerRadius = 15
        view.backgroundColor = .init(white: 0.3, alpha: 1)
        
        return view
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 70, height: 70)
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(ButtonSettingsCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.backgroundColor = .init(white: 0, alpha: 0)
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.allowsMultipleSelection = false
        view.reloadData()
        
        return view
    }()
    
    var upperTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "\(NSLocalizedString("chooseGroup", comment: ""))"
        
        return label
    }()
    
    var okButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitle("\(NSLocalizedString("ok", comment: ""))", for: .normal)
        button.addTarget(self, action: #selector(onOkButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitle("\(NSLocalizedString("cancel", comment: ""))", for: .normal)
        button.addTarget(self, action: #selector(onCancelButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let deviceIdKey = "DeviceId"
    
    var selectedDeviceId: String = ""
    var mainViewController: ViewController?
    var devices = [Deviceinfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewController.translatesAutoresizingMaskIntoConstraints = false
        upperTextLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewController)
        viewController.addSubview(upperTextLabel)
        viewController.addSubview(collectionView)
        viewController.addSubview(cancelButton)
        viewController.addSubview(okButton)
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        apiRequest()
    }
    
    func apiRequest() {
           devices = []
           
           ApiManager.getAlldevicesRequest(onCompletion: { response in
               
               for dev in response.device ?? [] {
                   self.devices.append(dev)
               }
               self.collectionView.reloadData()
           })
       }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            viewController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewController.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.widthAnchor.constraint(equalToConstant: 300),
            viewController.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            upperTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            upperTextLabel.topAnchor.constraint(equalTo: viewController.topAnchor, constant: 10),
            upperTextLabel.leadingAnchor.constraint(equalTo: viewController.leadingAnchor, constant: 10),
            upperTextLabel.trailingAnchor.constraint(equalTo: viewController.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: upperTextLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: viewController.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: viewController.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: viewController.leadingAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: viewController.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancelButton.trailingAnchor),
            okButton.trailingAnchor.constraint(equalTo: viewController.trailingAnchor, constant: -10),
            okButton.bottomAnchor.constraint(equalTo: viewController.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func onCancelButtonPressed() {
        self.view.removeFromSuperview()
    }
    
    @objc func onOkButtonPressed() {
        // send selectedDeviceId value to deviceId in ViewController
        if selectedDeviceId != "" {
            UserDefaults.standard.removeObject(forKey: deviceIdKey)
            UserDefaults.standard.set(selectedDeviceId, forKey: deviceIdKey)
            
            self.view.removeFromSuperview()
        }
    }
}

// MARK: Collection view
extension ButtonSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count //GetInfoAboutAllDevices.instance.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? ButtonSettingsCollectionViewCell else {
            fatalError()
        }
        
        let device = devices[indexPath.row] //GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.setNameToLabel(name: device.name ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = UIColor(displayP3Red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        cell?.layer.cornerRadius = 8
        
        let deviceId = devices[indexPath.row] //GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        selectedDeviceId = deviceId.id ?? ""
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        cell?.backgroundColor = UIColor.clear
        cell?.layer.cornerRadius = 8
    }
    
    
    
}
