//
//  AllDevicesInCollectionViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesInCollectionViewController: UIViewController {

    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        DevicesInput.getDevicesInfo(url: "https://api.telldus.com/json/devices/list")
        configurCollectionView()
    }
    
    func configurCollectionView() {
//        print("!!!!!!!!!! 1")
//        collectionView?.delegate = self
//        print("!!!!!!!!!! 2")
//        collectionView?.dataSource = self
//        print("!!!!!!!!!! 3")
//        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        print("!!!!!!!!!! 4")
////        self.view.addSubview(collectionView)
//        print("!!!!!!!!!! 5")
//        constraintsForTheTableView()
    }
    
    func constraintsForTheTableView() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       }
}

extension AllDevicesInCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UICollectionViewCell else {
            fatalError("error")
        }
//        let device = DevicesInput.devices[indexPath.row]
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    
}


