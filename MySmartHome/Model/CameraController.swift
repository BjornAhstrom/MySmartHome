//
//  CameraController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-24.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class CameraController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    let pickerController = UIImagePickerController()
    
    func openCameraOrPhotoLibraryAlert() {
            let alert = UIAlertController(title: "Choose", message: "Camera or photo library", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(_) in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(_) in
                self.openPhotoLibrary()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in
                print("Cancel")
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
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any], onCompletion: @escaping (UIImage) -> Void) {
            picker.dismiss(animated: true)
            
            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            
            onCompletion(image)
    //        backgroundView.image = image
    //
    //        let groupId = "\(self.thisGroupId ?? 0)"
    //        self.saveImage(imageName: groupId)
        }
        
        func alertWhenNoCamera() {
            let alert = UIAlertController(title: "No camera", message: "Your device doesn't have a camera", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {(_) in }))
            
            present(alert, animated: true)
        }
    
    
    
//    func saveImage(imageName: String) {
//        // Create an instance of the fileManager
//        let fileManager = FileManager.default
//
//        // Get the image path
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
//
//        // Get the image we took
//        let image = self.backgroundView.image
//
//        // Get the png data for this image
//        let data = image?.pngData()
//
//        // Store it in the document directory
//        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
//
//        // When the image is saved, go back to viewController
//        self.goBackToViewController()
//    }
}
