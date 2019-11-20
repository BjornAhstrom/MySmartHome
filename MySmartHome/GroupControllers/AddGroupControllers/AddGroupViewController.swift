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
        textField.text = ""
        
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
        label.text = ""
        
        return label
    }()
    
    var addDevicesButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(addDeviceButtonPressed), for: .touchUpInside)
        
        return button
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
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer?
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var devicesId: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        devicesLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addDevicesButton.translatesAutoresizingMaskIntoConstraints = false
        newGroupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(devicesLabel)
        view.addSubview(collectionView)
        view.addSubview(addDevicesButton)
        view.addSubview(activityIndicator)
        view.addSubview(newGroupNameTextField)
        
        setConstraints()
        self.hideKeyBoard()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
        
        collectionView.addGestureRecognizer(longPressGesture ?? UILongPressGestureRecognizer())
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            newGroupNameTextField.widthAnchor.constraint(equalToConstant: 300),
            newGroupNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            newGroupNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            devicesLabel.widthAnchor.constraint(equalToConstant: 300),
            devicesLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            devicesLabel.centerYAnchor.constraint(equalTo: newGroupNameTextField.centerYAnchor, constant: 50),
            devicesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addDevicesButton.widthAnchor.constraint(equalToConstant: 100),
            addDevicesButton.heightAnchor.constraint(equalToConstant: 40),
            addDevicesButton.topAnchor.constraint(equalTo: devicesLabel.bottomAnchor, constant: 20),
            addDevicesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: addDevicesButton.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func addDeviceButtonPressed() {
        showAddGroupAlert()
    }
    
    func addNewGroup() {
        loadActivityIndicator()
        let text = devicesLabel.text
        let groupName = newGroupNameTextField.text
        let str = text?.dropLast()
        
        // clientId 75884
        DeviceInfoOutput.instance.createNewDeviceGroupName(clientId: "75884", groupName: groupName ?? "", devices: String(str ?? ""), onCompletion: { response in
            
            if groupName != "" {
                self.showAlertWhenNewGroupName(groupName: groupName ?? "", alertMessage: response)
                self.removeActivityIndicator()
            } else {
                self.showAlertWhenNoGroupName(alertMessage: response)
                self.removeActivityIndicator()
            }
        })
        if groupName != "" {
            self.goBackToViewControllerWhenOkButtonInAlertIsPressed()
        }
    }
    
    // ActivityIndicator
    func loadActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
    
    func goBackToViewControllerWhenOkButtonInAlertIsPressed() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

// CollectionView
extension AddGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GetInfoAboutAllDevices.instance.deviceCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? GroupCollectionViewCell else {
            fatalError("Something went wrong to the cell")
        }
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
        
        cell.setTextAndImageToCell(name: device?.name ?? "", image: UIImage(named: "") ?? UIImage())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = UIColor.darkGray
        cell?.layer.cornerRadius = 10
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
        
        devicesId.updateValue(indexPath.row, forKey: device)
        
        devicesLabel.text? += "\(device),"
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        cell?.layer.cornerRadius = 10
        
        let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
        
        devicesId.removeValue(forKey: device)
        let str1 = devicesLabel.text ?? ""
        let str2 = str1.replacingOccurrences(of: "\(device),", with: "", options: String.CompareOptions.literal, range: nil)
        
        devicesLabel.text = str2
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
}

// Alert popup controllers
extension AddGroupViewController {
    
    public func showAddGroupAlert() {
        let newGroup = newGroupNameTextField.text
        let alert = UIAlertController(title: "Add group", message: newGroup, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default, handler: { (error) in
            print(error)
            self.addNewGroup()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in })
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func showAlertWhenNoGroupName(alertMessage: String) {
        
        let alert = UIAlertController(title: "No group name", message: alertMessage, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in })
        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true)
    }
    
    func showAlertWhenNewGroupName(groupName: String, alertMessage: String) {
        
        let alert = UIAlertController(title: groupName, message: alertMessage, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in })
        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true)
    }
}