//
//  AddGroupViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-12.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import AVFoundation

class AddGroupViewController: UIViewController {
    
    var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.backgroundColor = .white
        imageView.contentMode =  .scaleAspectFill
//        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var newGroupNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.textColor = .darkGray
        textField.placeholder = "\(NSLocalizedString("newGroupName", comment: ""))"
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
    
//    var addPhotoButton: UIButton = {
//        let button = UIButton()
//        button.layer.borderColor = UIColor.darkGray.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 8
//        button.backgroundColor = .white
//        button.setTitle("Add photo", for: .normal)
//        button.setTitleColor(.darkGray, for: .normal)
//        button.setTitleColor(.systemGray2, for: .highlighted)
//        button.addTarget(self, action: #selector(onPressedAddPhotoButton), for: .touchUpInside)
//
//        return button
//    }()
    
    var addDevicesButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitle("\(NSLocalizedString("save", comment: ""))", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(saveGroupButtonPressed), for: .touchUpInside)
        
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
        view.backgroundColor = .init(white: 1, alpha: 0.0)
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer?
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let pickerController = UIImagePickerController()
    var thisGroupId: Int?
    var devicesId: [String: Int] = [:]
    var devices = [Deviceinfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 1, alpha: 0.5)
        
        pickerController.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        devicesLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addDevicesButton.translatesAutoresizingMaskIntoConstraints = false
        newGroupNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(devicesLabel)
        self.view.addSubview(collectionView)
//        self.view.addSubview(addPhotoButton)
        self.view.addSubview(addDevicesButton)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(newGroupNameTextField)
        
        setConstraints()
        self.hideKeyBoard()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture ?? UILongPressGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.insertSubview(self.backgroundView, at: 0)
        apiRequest()
    }
    
    func apiRequest() {
           devices = []
           
           ApiManager.getAlldevicesRequest(onCompletion: { response in
               
            DispatchQueue.main.async {
                for dev in response.device ?? [] {
                    self.devices.append(dev)
                }
                self.collectionView.reloadData()
            }
           })
       }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            newGroupNameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            newGroupNameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            newGroupNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            devicesLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            devicesLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            devicesLabel.centerYAnchor.constraint(equalTo: self.newGroupNameTextField.centerYAnchor, constant: 50),
            devicesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            addPhotoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
//            addPhotoButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
//            addPhotoButton.topAnchor.constraint(equalTo: self.devicesLabel.bottomAnchor, constant: 20),
//            addPhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//        ])
        
        NSLayoutConstraint.activate([
            addDevicesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            addDevicesButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            addDevicesButton.topAnchor.constraint(equalTo: self.devicesLabel.bottomAnchor, constant: 20),
            addDevicesButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.addDevicesButton.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    @objc func saveGroupButtonPressed() {
        showConfirmGroupAlert()
    }
    
    @objc func onPressedAddPhotoButton() {
        print("Add Photo")
        openCameraOrPhotoLibraryAlert()
    }
    
    
    // MARK: Save new group
    func saveNewGroup() {
        loadActivityIndicator()
        let text = devicesLabel.text
        let str = text?.dropLast()
        let groupName = newGroupNameTextField.text
        
        // clientId 75884
        ApiManager.createNewDeviceGroupName(clientId: "75884", groupName: groupName ?? "",  devices: String(str ?? ""), onCompletion: { (response, id) in
            
            DispatchQueue.main.async {
                if groupName != "" {
                    self.thisGroupId = id
                    //                    self.showAlertWhenNewGroupName(groupName: groupName ?? "", alertMessage: response)
                    //                    self.removeActivityIndicator()
                    self.addPhotoNowOrLater()
                } else {
                    self.showAlertWhenNoGroupName(alertMessage: response)
                    self.removeActivityIndicator()
                }
            }
        })
    }
    
    // ActivityIndicator
    func loadActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
    
    func goBackToViewController() {
        removeActivityIndicator()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CollectionView
extension AddGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count //GetInfoAboutAllDevices.instance.deviceCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? GroupCollectionViewCell else {
            fatalError("Something went wrong to the cell")
        }
        
        cell.layer.masksToBounds = true
        cell.backgroundColor = .init(white: 0.5, alpha: 0.5)
        cell.layer.cornerRadius = 5
        
        if devices.count > 0 {
            let device = devices[indexPath.row]  //GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
            
            cell.setTextAndImageToCell(name: device.name ?? "")
        } else {
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        cell?.layer.masksToBounds = true
        cell?.backgroundColor = .init(white: 0.3, alpha: 0.5)
        cell?.layer.cornerRadius = 5
        
        if devices.count > 0 {
            let device = devices[indexPath.row].id ?? "" //GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
            
            devicesId.updateValue(indexPath.row, forKey: device)
            
            devicesLabel.text? += "\(device),"
        } else {
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.masksToBounds = true
        cell?.backgroundColor = .init(white: 0.5, alpha: 0.5)
        cell?.layer.cornerRadius = 5
        
        if devices.count > 0 {
            let device = devices[indexPath.row].id ?? "" //GetInfoAboutAllDevices.instance.devices(index: indexPath.row)?.id ?? ""
            
            devicesId.removeValue(forKey: device)
            
            let str1 = devicesLabel.text ?? ""
            let str2 = str1.replacingOccurrences(of: "\(device),", with: "", options: String.CompareOptions.literal, range: nil)
            
            devicesLabel.text = str2
        } else {
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if devices.count > 0 {
            let device = devices.remove(at: sourceIndexPath.item)
            devices.insert(device, at: destinationIndexPath.item)
        } else {
            return
        }
        
    }
}

// MARK: Alert,  popup controllers
extension AddGroupViewController {
    
    // Display this warning if the user want to confirm or dissmis the new group
    public func showConfirmGroupAlert() {
        let newGroup = newGroupNameTextField.text
        let alert = UIAlertController(title: "\(NSLocalizedString("addGroup", comment: ""))", message: newGroup, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "\(NSLocalizedString("ok", comment: ""))", style: .default, handler: { (error) in
            print(error)
            self.saveNewGroup()
            self.removeActivityIndicator()
        })
        
        let cancelAction = UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .cancel, handler: { (_) in })
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    // Display this warning if the user has not entered a group name
    func showAlertWhenNoGroupName(alertMessage: String) {
        
        let alert = UIAlertController(title: "\(NSLocalizedString("noGroupName", comment: ""))", message: alertMessage, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "\(NSLocalizedString("ok", comment: ""))", style: .destructive, handler: { (_) in })
        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true)
    }
    
    // Diplay this alert if the new group is an success
    func showAlertWhenNewGroupName(groupName: String, alertMessage: String) {
        
        let alert = UIAlertController(title: groupName, message: alertMessage, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "\(NSLocalizedString("ok", comment: ""))", style: .destructive, handler: { (_) in })
        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true)
    }
    
    // Ask user if the user want to add a background photo now or later
    func addPhotoNowOrLater() {
        let alert = UIAlertController(title: "\(NSLocalizedString("addPhoto", comment: ""))", message: "\(NSLocalizedString("youCanDoItLater", comment: ""))", preferredStyle: .alert)
        
        let now = UIAlertAction(title: "\(NSLocalizedString("addNow", comment: ""))", style: .default, handler: {(_) in
            // Open camera
            self.openCameraOrPhotoLibraryAlert()
        })
        
        let later = UIAlertAction(title: "\(NSLocalizedString("later", comment: ""))", style: .cancel, handler: {(_) in
            // Go back to ViewController
            self.goBackToViewController()
        })
        
        alert.addAction(now)
        alert.addAction(later)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Camera, Open camera or photo library to set background when user will create an group
extension AddGroupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
        func openCameraOrPhotoLibraryAlert() {
        let alert = UIAlertController(title: "\(NSLocalizedString("choose", comment: ""))", message: "\(NSLocalizedString("cameraOrPhotoLibrary", comment: ""))", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("camera", comment: ""))", style: .default, handler: {(_) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("photoLibrary", comment: ""))", style: .default, handler: {(_) in
            self.openPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .cancel, handler: {(_) in
//        print("Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // open camera if the device have a camera, or an alert sign will show up and tell to user that the user doesn't have a camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.pickerController.sourceType = .camera
            self.pickerController.allowsEditing = true
            present(self.pickerController, animated: true)
        } else {
            self.alertWhenNoCamera()
        }
    }
    
    func openPhotoLibrary() {
        self.pickerController.sourceType = .photoLibrary
        self.pickerController.allowsEditing = true
        present(self.pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        backgroundView.image = image
        
        let groupId = "\(self.thisGroupId ?? 0)"
        self.saveImage(imageName: groupId)
    }
    
    func alertWhenNoCamera() {
        let alert = UIAlertController(title: "\(NSLocalizedString("noCamera", comment: ""))", message: "\(NSLocalizedString("yourDeviceDoesntHaveACamera", comment: ""))", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("ok", comment: ""))", style: .destructive, handler: {(_) in }))
        
        present(alert, animated: true)
    }
    
    func saveImage(imageName: String) {
        // Create an instance of the fileManager
        let fileManager = FileManager.default
        
        // Get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        // Get the image we took
        let image = self.backgroundView.image
        
        // Get the png data for this image
        let data = image?.pngData()
        
        // Store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        // When the image is saved, go back to viewController
        self.goBackToViewController()
    }
}
