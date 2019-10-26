//
//  IngredientNutritionCard.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit

class IngredientNutritionCard: UIView {
    
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
    var weightLabel: UILabel!
    var horizontalLine: UIView!
    var proteinTitle: UILabel!
    var proteinValue: UILabel!
    var carbohydrateTitle: UILabel!
    var carbohydrateValue: UILabel!
    var fatTitle: UILabel!
    var fatValue: UILabel!
    
    
    func setupView() {
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.darkGray.cgColor
        
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.nameLabel = UILabel(frame: CGRect(x: 12, y: 8, width: 140, height: 30))
        nameLabel.text = "blueberries"
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        nameLabel.textColor = UIColor.darkGray
        nameLabel.numberOfLines = 0
        nameLabel.contentMode = .scaleToFill
        nameLabel.textAlignment = .left
//        nameLabel.alpha = 0
        
        self.addSubview(nameLabel)
        
        self.weightLabel = UILabel(frame: CGRect(x: self.frame.width - 12 - 100, y: 8, width: 100, height: 30))
        weightLabel.text = "37g"
        weightLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        weightLabel.textColor = UIColor.darkGray
        weightLabel.numberOfLines = 0
        weightLabel.contentMode = .scaleToFill
        weightLabel.textAlignment = .right
//        weightLabel.alpha = 0
        
        self.addSubview(weightLabel)
        
        horizontalLine = UIView(frame: CGRect(x: 6, y: self.nameLabel.frame.origin.y + self.nameLabel.frame.height, width: self.frame.width - 12, height: 2))
        horizontalLine.center.x = self.frame.width / 2
        horizontalLine.backgroundColor = UIColor(red:0.93, green:0.36, blue:0.56, alpha:1.0)
        self.addSubview(horizontalLine)
        
        
        self.proteinTitle = UILabel(frame: CGRect(x: 12, y: self.horizontalLine.frame.origin.y + 2 + 12, width: 100, height: 25))
        proteinTitle.text = "protein"
        proteinTitle.font = UIFont.systemFont(ofSize: 15, weight: .light)
        proteinTitle.textColor = UIColor.darkGray
        proteinTitle.numberOfLines = 0
        proteinTitle.contentMode = .scaleToFill
        proteinTitle.textAlignment = .left
//        proteinTitle.alpha = 0
        
        self.addSubview(proteinTitle)
        
        self.proteinValue = UILabel(frame: CGRect(x: self.frame.width - 12 - 100, y: self.horizontalLine.frame.origin.y + 2 + 12, width: 100, height: 25))
        proteinValue.text = "14g"
        proteinValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        proteinValue.textColor = UIColor.darkGray
        proteinValue.numberOfLines = 0
        proteinValue.contentMode = .scaleToFill
        proteinValue.textAlignment = .right
//        proteinValue.alpha = 0
        
        self.addSubview(proteinValue)
        
        self.carbohydrateTitle = UILabel(frame: CGRect(x: 12, y: self.proteinTitle.frame.origin.y + self.proteinTitle.frame.height + 12, width: 100, height: 25))
        carbohydrateTitle.text = "carbs"
        carbohydrateTitle.font = UIFont.systemFont(ofSize: 15, weight: .light)
        carbohydrateTitle.textColor = UIColor.darkGray
        carbohydrateTitle.numberOfLines = 0
        carbohydrateTitle.contentMode = .scaleToFill
        carbohydrateTitle.textAlignment = .left
//        carbohydrateTitle.alpha = 0
        
        self.addSubview(carbohydrateTitle)
        
        self.carbohydrateValue = UILabel(frame: CGRect(x: self.frame.width - 12 - 100, y: self.proteinTitle.frame.origin.y + self.proteinTitle.frame.height + 12, width: 100, height: 25))
        carbohydrateValue.text = "14g"
        carbohydrateValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        carbohydrateValue.textColor = UIColor.darkGray
        carbohydrateValue.numberOfLines = 0
        carbohydrateValue.contentMode = .scaleToFill
        carbohydrateValue.textAlignment = .right
//        carbohydrateValue.alpha = 0
        
        self.addSubview(carbohydrateValue)
        
        
        self.fatTitle = UILabel(frame: CGRect(x: 12, y: self.carbohydrateTitle.frame.origin.y + self.carbohydrateTitle.frame.height + 12, width: 100, height: 25))
        fatTitle.text = "fat"
        fatTitle.font = UIFont.systemFont(ofSize: 15, weight: .light)
        fatTitle.textColor = UIColor.darkGray
        fatTitle.numberOfLines = 0
        fatTitle.contentMode = .scaleToFill
        fatTitle.textAlignment = .left
//        fatTitle.alpha = 0
        
        self.addSubview(fatTitle)
        
        self.fatValue = UILabel(frame: CGRect(x: self.frame.width - 12 - 100, y: self.carbohydrateTitle.frame.origin.y + self.carbohydrateTitle.frame.height + 12, width: 100, height: 25))
        fatValue.text = "14g"
        fatValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        fatValue.textColor = UIColor.darkGray
        fatValue.numberOfLines = 0
        fatValue.contentMode = .scaleToFill
        fatValue.textAlignment = .right
//        fatValue.alpha = 0
        
        self.addSubview(fatValue)
        
        
        
        self.actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(actionButton)
        
    }
    
    func setBackgroundColor(hex: UIColor) {
        self.layer.backgroundColor = hex.cgColor
    }
    
    func setTitle(text: String) {
        self.nameLabel.text = text
    }
    func setNutritionalInformation(proteinVal: String, carbVal: String, fatVal: String) {
        
        self.proteinValue.text = proteinVal
        self.carbohydrateValue.text = carbVal
        self.fatValue.text = fatVal
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
