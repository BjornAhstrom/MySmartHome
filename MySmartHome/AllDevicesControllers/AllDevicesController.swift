//
//  AllDevicesController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-20.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class AllDevicesController: UIViewController {
    
    var backgroundView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "Background")
        
        return image
    }()
    
    var viewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "Your devices"
        
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
        view.register(AllDevicesCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        view.backgroundColor = .init(white: 0, alpha: 0.0)
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer?
    var sliderValue: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.addSubview(viewLabel)
        view.addSubview(collectionView)
        
        setConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(sender:)))
        
        collectionView.addGestureRecognizer(longPressGesture ?? UILongPressGestureRecognizer())
    }
    
    @objc func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        
        let point = sender.location(in: collectionView)
        
        switch sender.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: point) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            viewLabel.heightAnchor.constraint(equalToConstant: 50),
            viewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            viewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 30),
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
        
        cell.layer.masksToBounds = true
        cell.backgroundColor = .init(white: 0.5, alpha: 0.5)
                cell.layer.cornerRadius = 5
        
        DispatchQueue.main.async {
             let device = GetInfoAboutAllDevices.instance.devices(index: indexPath.row)
                   
                   cell.setTextAndImageToCell(name: device?.name ?? "", image: UIImage(named: "") ?? UIImage())
                   
                   DeviceInfoOutput.instance.getDeviceInformation(id: device?.id ?? "", onCompletion: {(stateValue, deviceType)  in
                       
                       if deviceType == TelldusKeys.dimmableDeviceNr {
                           cell.sliderButton.isHidden = false
                           cell.setConstraints(sliderIsOn: true)
                           
                       } else {
                           cell.sliderButton.isHidden = true
                       }
                   })
                   
            cell.sliderButton.addTarget(self, action: #selector(self.setSliderValue), for: .touchUpInside)
                   
                   DeviceInfoOutput.instance.getHistory(id: device?.id ?? "", onCompletion: { (state, stateValue)  in
                       
                       cell.sliderButton.setTitle("% \(stateValue)", for: .normal)
                       
                       if state == 1 {
                           // Dvice is on
                           cell.imageView.image = UIImage(named: "LampOn")
                       }
                       else if state == 2  {
                           // Device is off
                           cell.imageView.image = UIImage(named: "LampOff")
                       }
                   })
            
            let textLength = Double(cell.textLabel.text?.count ?? 0)
            
                DispatchQueue.main.async(execute: {
                    
                    UIView.animate(withDuration: 10, delay: 1.3, options: ([.curveLinear, .repeat]), animations: {() -> Void in
                        
                        cell.textLabel.transform = CGAffineTransform(translationX: cell.textLabel.bounds.origin.x - 200, y: cell.textLabel.bounds.origin.y)
                        
                    }, completion:  nil)
                })
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let device = GetInfoAboutAllDevices.instance.devices.remove(at: sourceIndexPath.item)
        GetInfoAboutAllDevices.instance.devices.insert(device, at: destinationIndexPath.item)
    }
    
    @objc func setSliderValue() {
        print("SliderButtonTouch")
        
        let popup = PopupSliderViewController()
        self.addChild(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
    
    func setValueToCell(cell: UICollectionViewCell) {
        
    }
}
