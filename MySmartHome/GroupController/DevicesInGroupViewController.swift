//
//  DevicesInGroupViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DevicesInGroupViewController: UIViewController {
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 80)
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(DevicesInGroupCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.backgroundColor = UIColor.systemBackground
        view.allowsMultipleSelection = true
        view.reloadData()
        
        return view
    }()
    
    var removeGroupLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Remove group"
        
        return label
    }()
    
    var removeGroupButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        
        button.setTitle("Remove group", for: .normal)
        
        return button
    }()
    
    var buttons: [GroupButton] = []
    var selectedButtons: [ListOfSelectedButtons] = []
    
    var groupId: String = "" // group id
    var devicesId: String = "" // all ids from the group
    var devicesIds: [String] = [] // split string from deviceId in to this array
    
    var isOn: Bool = false
    var currentDeviceId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //        DeviceInfoOutput.instance.getDeviceInformation(id: groupId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        removeGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        removeGroupButton.translatesAutoresizingMaskIntoConstraints = false
        
        devicesIds = devicesId.components(separatedBy: ",")
        
        view.addSubview(collectionView)
        view.addSubview(removeGroupLabel)
        view.addSubview(removeGroupButton)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            removeGroupLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            removeGroupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            removeGroupLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: removeGroupLabel.bottomAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            removeGroupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            removeGroupButton.leadingAnchor.constraint(greaterThanOrEqualTo: removeGroupLabel.trailingAnchor, constant: 20),
            removeGroupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            removeGroupButton.heightAnchor.constraint(equalToConstant: 40),
            removeGroupButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// CollectionView
extension DevicesInGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? DevicesInGroupCollectionViewCell else {
            fatalError()
        }
        let devId = devicesIds[indexPath.row]
        
        DeviceInfoOutput.instance.getGroupInformation(id: devId, onCompletion: { devName in
            cell.setDeviceNameToLabel(name: devName, image: UIImage(named: "Lamp") ?? UIImage())
        })
        
        DeviceInfoOutput.instance.getHistory(id: devId, onCompletion: { (state) in
            print(state)
            
            if state == 1 {
                cell.backgroundColor = UIColor.clear
                cell.layer.cornerRadius = 10
            }
            else if state == 2 {
                cell.backgroundColor = UIColor(displayP3Red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
                cell.layer.cornerRadius = 10
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let devId = devicesIds[indexPath.row]
        
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = UIColor.clear
        cell?.layer.cornerRadius = 10
        
        DeviceInfoOutput.instance.turnOnDevice(id: devId)
        print("On: \(devId)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let devId = devicesIds[indexPath.row]
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(displayP3Red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        cell?.layer.cornerRadius = 10
        
        DeviceInfoOutput.instance.turnOffDevice(id: devId)
        print("Off: \(devId)")
    }
}

//// Mockdata
//extension DevicesInGroupViewController {
//
//    func mockData() -> [GroupButton] {
//        let button1 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test1")
//        let button2 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test2")
//        let button3 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test3")
//        let button4 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test4")
//        let button5 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test5")
//        let button6 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test6")
//        let button7 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test7")
//        let button8 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test8")
//        let button9 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test9")
//        let button10 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test10")
//        let button11 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test11")
//        let button12 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test12")
//
//        return [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12]
//
//    }
//}
