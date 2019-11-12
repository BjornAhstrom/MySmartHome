//
//  AddGroupViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {
    
    var newGroupNameTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.textColor = .darkGray
        textField.placeholder = "New group name"
        
        return textField
    }()
    
    var devicesLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 18)
        label.text = "3243,324234,123423,"
        
        return label
    }()
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 60)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.backgroundColor = UIColor.systemBackground
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    var devicesId: [String: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        devicesLabel.translatesAutoresizingMaskIntoConstraints = false
        newGroupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(devicesLabel)
        view.addSubview(newGroupNameTextField)
        view.addSubview(collectionView)
        
        setConstraints()
        self.hideKeyBoard()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            newGroupNameTextField.widthAnchor.constraint(equalToConstant: 300),
            newGroupNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            newGroupNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            devicesLabel.widthAnchor.constraint(equalToConstant: 300),
            devicesLabel.centerYAnchor.constraint(equalTo: newGroupNameTextField.centerYAnchor, constant: 50),
            devicesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: devicesLabel.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

// CollectionView
extension AddGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GetInfoAboutAllDevices.instance.deviceCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? GroupCollectionViewCell else {
            fatalError("Something went wrong to th cell")
        }
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        cell.setTextAndImageToCell(name: device?.name ?? "", image: UIImage(named: "Lamp") ?? UIImage())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = UIColor.darkGray
        cell?.layer.cornerRadius = 10
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
        
        devicesId.updateValue(indexPath.row, forKey: device)
        
        
        print(devicesId)
        
        print("Selected \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        cell?.layer.cornerRadius = 10
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
        
        devicesId.removeValue(forKey: device)
        
        print(devicesId)
        
        print("Deselected \(indexPath.row)")
        
        for i in devicesId {
            print(i)
        }
    }
    
}
