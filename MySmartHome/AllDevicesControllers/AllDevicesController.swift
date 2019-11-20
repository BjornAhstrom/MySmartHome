//
//  AllDevicesController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesController: UIViewController {
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 60)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(AllDevicesCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.backgroundColor = UIColor.white
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        setConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}

extension AllDevicesController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GetInfoAboutAllDevices.instance.deviceCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? AllDevicesCollectionViewCell else {
            fatalError("Something went wrong to the cell")
        }
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        cell.setTextAndImageToCell(name: device?.name ?? "", image: UIImage(named: "") ?? UIImage())
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        DeviceInfoOutput.instance.getDeviceInformation(id: device?.id ?? "", onCompletion: {(stateValue, deviceType)  in
            
            if deviceType == TelldusKeys.dimmableDeviceNr {
                cell.slider.isHidden = false
                cell.setConstraints(sliderIsOn: true)
                
            } else {
                cell.slider.isHidden = true
            }
        })
        
        DeviceInfoOutput.instance.getHistory(id: device?.id ?? "", onCompletion: { (state, stateValue)  in
            
            if state == 1 {
                // Dvice is on
                cell.imageView.image = UIImage(named: "LampOn")
            }
            else if state == 2  {
                // Device is off
                cell.imageView.image = UIImage(named: "LampOff")
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        print(device?.id ?? "")
        DeviceInfoOutput.instance.turnOnDevice(id: device?.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        DeviceInfoOutput.instance.turnOffDevice(id: device?.id ?? "")
        
    }
    
}
