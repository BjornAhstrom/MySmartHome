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
        image.image = UIImage(named: "Background3")
        
        return image
    }()
    
    var viewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "\(NSLocalizedString("yourDevices", comment: ""))"
        
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
        view.register(AllDevicesCollectionViewCell.self, forCellWithReuseIdentifier: self.myCell)
        view.backgroundColor = .init(white: 0, alpha: 0.0)
        view.allowsMultipleSelection = true
        
        //        if #available(iOS 10.0, *) {
        //            view.refreshControl = self.refreshControl
        //        } else {
        //            view.addSubview(self.refreshControl)
        //        }
        //        self.refreshControl.addTarget(self, action: #selector(updateCollectionView), for: .valueChanged)
        return view
    }()
    
    let myCell = "MyCell"
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer?
    lazy var refreshControl = UIRefreshControl()
    
    var sliderValue: Float = 0.0
    var xAndYValueFromCellWithSlider = CGRect()
    var deviceId: String = ""
    var devices: [Deviceinfo] = []
    var timer: DispatchSourceTimer?
    
    static var uiView: UIView = UIView()
    
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
        
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(sender:)))
        collectionView.addGestureRecognizer(longPressGesture ?? UILongPressGestureRecognizer())
        
        self.apiRequest()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        print("ViewWillDisappear")
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
    
    //    @objc func updateCollectionView() {
    //
    //        DispatchQueue.main.async {
    //            self.apiRequest()
    //        }
    //
    //        self.collectionView.reloadData()
    //        self.refreshControl.endRefreshing()
    //    }
    
    func apiRequest() {
        self.devices = []
        ApiManager.getAlldevicesRequest(onCompletion: { response in
            
            for dev in response.device ?? [] {
                self.devices.append(dev)
            }
            self.collectionView.reloadData()
        })
        
        let queue = DispatchQueue.global(qos: .background)
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer?.schedule(deadline: .now(), repeating: .milliseconds(2000), leeway: .seconds(1))
        self.timer?.setEventHandler(handler: {
            
        })
        self.timer?.resume()
        
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

// MARK: collection view for all devices
extension AllDevicesController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.myCell, for: indexPath) as? AllDevicesCollectionViewCell else {
            fatalError("Something went wrong with the cell")
        }
        
        cell.layer.masksToBounds = true
        cell.backgroundColor = .init(white: 0.3, alpha: 0.7)
        cell.layer.cornerRadius = 5
        
        if devices.count > 0 {
            
            let device = devices[indexPath.row]
            
            cell.onOffButton.deviceId = device.id ?? ""

            ApiManager.getDeviceInformation(id: device.id ?? "", onCompletion: {(stateValue, deviceType, type)  in
                
                DispatchQueue.main.async {
                    if deviceType == TelldusKeys.dimmableDeviceNr {
                        cell.sliderButton.isHidden = false
                        cell.setConstraints(sliderIsOn: true)
                        self.xAndYValueFromCellWithSlider = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: 0, height: 0)
                        self.deviceId = device.id ?? ""
                        
                        let value = Double(stateValue)
                        let stV = (value ?? 0)/2.55
                        
                        cell.sliderButton.setTitle("\(Int(stV)) % ", for: .normal)
                    } else {
                        cell.sliderButton.isHidden = true
                    }
                }
            })
            
//            UIView.animate(withDuration: 10, delay: 1, options: [.curveLinear, .repeat], animations: {
//                cell.textLabel.transform = CGAffineTransform(translationX: cell.textLabel.bounds.origin.x - 200, y: cell.textLabel.bounds.origin.y)
//                
//            })
            
            DispatchQueue.main.async {
                cell.setTextAndImageToCell(name: device.name ?? "")
                
            }
                        cell.sliderButton.addTarget(self, action: #selector(self.setSliderValue), for: .touchUpInside)
            
        } else {
            print("The array is empty")
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let device = devices.remove(at: sourceIndexPath.item)
        devices.insert(device, at: destinationIndexPath.item)
    }
    
    @objc func setSliderValue() {
        let popup = PopupSliderViewController()
        self.addChild(popup)
        popup.xAndYValueSlider = xAndYValueFromCellWithSlider
        popup.deviceId = deviceId
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
}
