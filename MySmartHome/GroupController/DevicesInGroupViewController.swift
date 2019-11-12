//
//  DevicesInGroupViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DevicesInGroupViewController: UIViewController {
    
    var buttons: [GroupButton] = []
    var selectedButtons: [ListOfSelectedButtons] = []
    
    var groupId: String = "" // group id
    var devicesId: String = "" // all ids from the group
    var devicesIds: [String] = [] // splitted string from deviceId
    var devices: [DeviceList] = []
    
//    fileprivate var longPressGesture: UILongPressGestureRecognizer?
    
//    var collectionView: UICollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devicesIds = devicesId.components(separatedBy: ",")
        
//        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
//
//        collectionView.addGestureRecognizer(longPressGesture ?? UILongPressGestureRecognizer())
        
        buttons = mockData()
//        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DeviceInfoOutput.instance.getDeviceInformation(id: deviceId)
        configureCollectionView()
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 200, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 60)
        
        let collectionView: UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.allowsMultipleSelection = true
        
        view.addSubview(collectionView)
    }
    
//    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
//                break
//            }
//            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case .changed:
//            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
//        case .ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }
    
//    func setConstraintsOnCollectionView() {
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
}

// CollectionView
extension DevicesInGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesIds.count  //buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? GroupCollectionViewCell else {
            fatalError()
        }
        
        let deviceId = devicesIds[indexPath.row]
        
        
        
//        TelldusKeys.oauthswift.client.get("https://api.telldus.com/json/device/info?id=3475345") { result in
//                       switch result {
//                       case.success(let response):
//                           let dataString = response.string
//
////                           let jsonData = dataString!.data(using: .utf8)
////                           let decoder = JSONDecoder()
////                           let device = try! decoder.decode(DeviceList.self, from: jsonData!)
//
////                           print("TEST \(device)")
//
//                       case.failure(let error):
//                           print(error.localizedDescription)
//                       }
//                   }
        
        
        
        
//        let lampButton = buttons[indexPath.row]
        
//        cell.setTextAndImageToCell(name: "", image: UIImage(named: "Lamp") ?? UIImage())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = UIColor.darkGray
        cell?.layer.cornerRadius = 10
        
//        let button = buttons[indexPath.row]
//
//        var selected = selectedButtons[indexPath.row]
        
        print("Selected \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        cell?.layer.cornerRadius = 10
        
        print("Deselected \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = buttons.remove(at: sourceIndexPath.item)
        buttons.insert(temp, at: destinationIndexPath.item)
        
        print("starting index: \(sourceIndexPath.item)")
        print("Ending index: \(destinationIndexPath.item)")
    }
}

// Mockdata
extension DevicesInGroupViewController {
    
    func mockData() -> [GroupButton] {
        let button1 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test1")
        let button2 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test2")
        let button3 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test3")
        let button4 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test4")
        let button5 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test5")
        let button6 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test6")
        let button7 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test7")
        let button8 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test8")
        let button9 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test test9")
        let button10 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test10")
        let button11 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test11")
        let button12 = GroupButton(image: UIImage(named: "Lamp") ?? UIImage(), id: "test12")
        
        return [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12]
        
    }
}
