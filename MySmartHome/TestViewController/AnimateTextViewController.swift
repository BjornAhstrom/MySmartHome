//
//  AnimateTextViewController.swift
//  MySmartHome
//
//  Created by Björn Åhström on 2019-11-26.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//
import Foundation
import UIKit

class AnimateTextViewController: UIView {
    
    enum Alignment {
        case left
        case right
    }
    
    public var textAlignment: Alignment = .left {
        didSet {
            layout()
        }
    }
    
    public var font: UIFont? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var textColor: UIColor? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var lines: [String] = [] {
        didSet {
            for label in labels {
                label.removeFromSuperview()
            }
            labels = []
            setNeedsLayout()
        }
    }
    
    private var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        
        autocreateLabels()
        
        var yPosition: CGFloat = 0.0
        for label in labels {
            let size = label.sizeThatFits(bounds.size)
            let minX = textAlignment == .left ? 0.0 : bounds.width - size.width
            let frame = CGRect(x: minX, y: yPosition, width: size.width, height: size.height)
            label.frame = frame
            yPosition = frame.maxY
        }
    }
    
    private func autocreateLabels() {
        if labels.count != lines.count {
            for text in lines {
                let label = UILabel()
                label.font = font
                label.textColor = textColor
                label.text = text
                addSubview(label)
                labels.append(label)
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autocreateLabels()
        
        var height: CGFloat = 0.0
        for label in labels {
            height = label.sizeThatFits(size).height
        }
        return CGSize(width: size.width, height: height)
    }
}
