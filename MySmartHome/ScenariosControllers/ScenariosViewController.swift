//
//  ScenariosViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-04.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ScenariosViewController: UIViewController {
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: layout.itemSize.width*3, height: 60)
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        view.register(ScenariosCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = .init(white: 0, alpha: 0.0)
        view.allowsMultipleSelection = true
        
        if #available(iOS 10.0, *) {
            view.refreshControl = self.refreshControl
        } else {
            view.addSubview(self.refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateCollectionView), for: .valueChanged)

        return view
    }()

    lazy var refreshControl = UIRefreshControl()
    var devices = [Deviceinfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        apiRequest()
    }
    
    func apiRequest() {
        devices = []
        
        ApiManager.getAlldevicesRequest(onCompletion: { response in
            
            for dev in response.device ?? [] {
                self.devices.append(dev)
            }
            self.collectionView.reloadData()
        })
    }
    
    @objc func updateCollectionView() {
        
        DispatchQueue.main.async {
            self.apiRequest()
        }
        
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: Collection View
extension ScenariosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ScenariosCollectionViewCell else {
            fatalError()
        }

        cell.layer.masksToBounds = true
        cell.backgroundColor = .init(white: 0.3, alpha: 0.7)
        cell.layer.cornerRadius = 5
        
        let device = devices[indexPath.row]
        cell.deviceNameLabel.text = device.name

        return cell
    }
}

