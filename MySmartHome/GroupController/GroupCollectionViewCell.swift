//
//  GroupCollectionViewCell.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        setConstraintsToImageCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraintsToImageCell() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
