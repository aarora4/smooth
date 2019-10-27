//
//  IngredientSegmentView.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit

class IngredientSegmentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
         
     //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
     
    var actionButton: UIButton!
    var nameLabel: UILabel!
    var selected: Bool = true
    var identifier: Int = 0
    var selectedColor: UIColor = UIColor.white
    var weight: Double!
    
    func setupView() {
        
//        self.layer.cornerRadius = 20
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width - 20, height: self.frame.height / 2))
        self.nameLabel.center.x = self.frame.width / 2
        self.nameLabel.center.y = self.frame.height / 2
        nameLabel.text = "blueberries"
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        nameLabel.textColor = UIColor.white
        nameLabel.numberOfLines = 0
        nameLabel.contentMode = .scaleToFill
        nameLabel.textAlignment = .center
//        nameLabel.alpha = 0
        
        self.addSubview(nameLabel)
        
        self.actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(actionButton)
        
    }
    
    func setBackgroundColor(hex: UIColor) {
        self.layer.backgroundColor = hex.cgColor
    }
    
    func toggleSelected() {
        
        
        if (selected) {
            selected = false
            nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
            
        } else {
            selected = true
            nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            
        }
    }
    
    func setTitle(text: String) {
        self.nameLabel.text = text
    }
    
    func setIdentifier(identifier: Int) {
        self.identifier = identifier
    }
    
    func setWeight(grams: Double) {
        weight = grams
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
