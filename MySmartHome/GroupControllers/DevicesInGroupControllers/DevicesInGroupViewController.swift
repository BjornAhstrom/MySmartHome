//
//  DevicesInGroupViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class DevicesInGroupViewController: UIViewController {
    
    var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode =  .scaleAspectFill
        
        return imageView
    }()
    
    var topView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .init(white: 0.3, alpha: 0.7)
        
        return view
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 80)
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(DevicesInGroupCollectionViewCell.self, forCellWithReuseIdentifier: self.myCell)
        view.backgroundColor = .init(white: 0, alpha: 0.0)
        view.allowsMultipleSelection = true
        view.reloadData()
        
        return view
    }()
    
    var removeGroupLabel: UILabel = {
        let label = UILabel()
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 8
//        label.backgroundColor = .init(white: 0.3, alpha: 0.7)
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "\(NSLocalizedString("labelRemoveGroup", comment: ""))"
        
        return label
    }()
    
    var removeGroupButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        button.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        
        button.setTitle("\(NSLocalizedString("buttonRemoveGroup", comment: ""))", for: .normal)
        
        return button
    }()
    
    let pickerController = UIImagePickerController()
    let myCell = "MyCell"
    
//    var buttons: [GroButton] = []
    
    var groupId: String = "" // group id
    var devicesId: String = "" // all ids from the group
    var devicesIds: [String] = [] // split string from deviceId in to this array
    
    var isOn: Bool = false
    var currentDeviceId: String = ""
    var groupName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pickerController.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        removeGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        removeGroupButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Remove the (,) token and split the string and adds the seperated string to an array.
        devicesIds = devicesId.components(separatedBy: ",")
        
        view.addSubview(backgroundView)
        view.addSubview(topView)
        view.addSubview(collectionView)
        view.addSubview(removeGroupLabel)
        view.addSubview(removeGroupButton)
        
        setConstraints()
        getImage(imageName: groupId)
        setupCameraButton()
       
    }
    
    // Set a camera button to the right in navigation bar
    func setupCameraButton() {
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(onCameraPressed))
        
        cameraButton.tintColor = .systemGray
        
        self.navigationItem.setRightBarButton(cameraButton, animated: true)
    }
    
    @objc func onCameraPressed() {
        openCameraOrPhotoLibraryAlert()
    }
    
    // Remove group from Telldus and image from the device
    @objc func removeButtonPressed() {
        print("Remove button pressed")
        deleteImage(ImageName: groupName)
        ApiManager.removeGroup(groupId: groupId, onCompletion: {(success, error) in
            
            print("\(success)")
            
            // Gör en alertController som talar om för användaren om det inte går att ta bort en grupp
            print("\(error)")
            
            DispatchQueue.main.async {
                self.goBackToViewController()
            }
        })
    }
    
    func goBackToViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // Öppna camera eller foto albumet för att lägga till bild
    
    // Save image to document directory
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
        //        self.goBackToViewController()
    }
    
    // Get the image from the device document directory
    func getImage(imageName: String) {
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            self.backgroundView.image = UIImage(contentsOfFile: imagePath)
        } else {
            print("No image")
        }
    }
    
    // Delete the image from the device document directory
    func deleteImage(ImageName: String) {
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as
            NSString).appendingPathComponent(ImageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            do {
                try fileManager.removeItem(atPath: imagePath)
            } catch {
                print("Could not find image")
            }
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 50),
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            removeGroupLabel.heightAnchor.constraint(equalToConstant: 40),
            removeGroupLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 5),
            removeGroupLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 7),
            removeGroupLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            removeGroupButton.heightAnchor.constraint(equalToConstant: 40),
            removeGroupButton.widthAnchor.constraint(equalToConstant: 150),
            removeGroupButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 5),
            removeGroupButton.leadingAnchor.constraint(greaterThanOrEqualTo: removeGroupLabel.trailingAnchor, constant: 20),
            removeGroupButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -7),
            removeGroupButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5)
            
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: CollectionView for all devices in group
extension DevicesInGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.myCell, for: indexPath) as? DevicesInGroupCollectionViewCell else {
            fatalError()
        }
        let devId = devicesIds[indexPath.row]
        
        ApiManager.getGroupInformation(id: devId, onCompletion: { (devName) in
            
            cell.setDeviceNameToLabel(name: devName)
        })
        
        cell.layer.masksToBounds = true
        cell.backgroundColor = .init(white: 0.5, alpha: 0.5)
        cell.layer.cornerRadius = 5
        
        ApiManager.getHistory(id: devId, onCompletion: { (state, stateValue)  in
            
            DispatchQueue.main.async {
                
                if state == 1 {
                    // Dvice is on
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                    cell.backgroundColor = .init(white: 0.7, alpha: 0.3)
                    cell.layer.cornerRadius = 10
                }
                else if state == 2 {
                    // Device is off
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.backgroundColor = .init(white: 0.3, alpha: 0.7)
                    cell.layer.cornerRadius = 10
                }
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let devId = devicesIds[indexPath.row]
        
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        cell?.backgroundColor = .init(white: 0.7, alpha: 0.3)
        cell?.layer.cornerRadius = 10
        
        ApiManager.turnOnDevice(id: devId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let devId = devicesIds[indexPath.row]
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .init(white: 0.3, alpha: 0.7)
        cell?.layer.cornerRadius = 10
        
        ApiManager.turnOffDevice(id: devId)
    }
}

// MARK: Camera, Open camera or photo library to set background when user will create an group
extension DevicesInGroupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func openCameraOrPhotoLibraryAlert() {
        let alert = UIAlertController(title: "\(NSLocalizedString("choose", comment: ""))", message: "\(NSLocalizedString("cameraOrPhotoLibrary", comment: ""))", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("camera", comment: ""))", style: .default, handler: {(_) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("photoLibrary", comment: ""))", style: .default, handler: {(_) in
            self.openPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .cancel, handler: {(_) in
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
//        print("Open library and id: \(groupId)")
        self.pickerController.sourceType = .photoLibrary
        self.pickerController.allowsEditing = true
        present(self.pickerController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.deleteImage(ImageName: self.groupId)
        
        DispatchQueue.main.async {
            self.backgroundView.image = image
        }
        
        DispatchQueue.main.async {
            self.saveImage(imageName: self.groupId)
        }
        
        picker.dismiss(animated: true)
    }
    
    func alertWhenNoCamera() {
        let alert = UIAlertController(title: "\(NSLocalizedString("noCamera", comment: ""))", message: "\(NSLocalizedString("yourDeviceDoesntHaveACamera", comment: ""))", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {(_) in }))
        
        present(alert, animated: true)
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
