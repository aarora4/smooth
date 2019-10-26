//
//  SmoothieView.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit

class SmoothieView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var cupImage: UIImageView!
    var smoothieNameLabel: UITextField!
    var shareButton: UIButton!
    var verticalScrollView: UIScrollView!
    var ingredients: [IngredientSegmentView] = []
    var ingredientCards: [IngredientNutritionCard] = []
    var totalCalories: UILabel!
    var editIcon: UIImageView!
    var pageControl: UIPageControl!
    
    
    
    

    func setupView() {
        
        smoothieNameLabel = UITextField(frame: CGRect(x: 0, y: 12, width: 200, height: 35))
        smoothieNameLabel.attributedPlaceholder = NSAttributedString(string: "My Smoothie",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        smoothieNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        smoothieNameLabel.textColor = UIColor.black
        
        smoothieNameLabel.contentMode = .scaleToFill
        smoothieNameLabel.textAlignment = .center
        smoothieNameLabel.center.x = self.frame.width / 2
//        smoothieNameLabel.alpha = 0
        self.addSubview(smoothieNameLabel)
        
        
        totalCalories = UILabel(frame: CGRect(x: 0, y: self.smoothieNameLabel.frame.origin.y + self.smoothieNameLabel.frame.height + 8, width: 200, height: 25))
        totalCalories.text = "438 Calories"
        totalCalories.font = UIFont.systemFont(ofSize: 20, weight: .light)
        totalCalories.textColor = UIColor.gray
        totalCalories.numberOfLines = 0
        totalCalories.contentMode = .scaleToFill
        totalCalories.textAlignment = .center
        totalCalories.center.x = self.frame.width / 2
//        totalCalories.alpha = 0
        self.addSubview(totalCalories)
        
        cupImage = UIImageView(frame: CGRect(x: 0, y: self.totalCalories.frame.origin.y + self.totalCalories.frame.height, width: 400, height: 400))
        cupImage.center.x = self.frame.width / 2
        cupImage.contentMode = .scaleAspectFit
        cupImage.image = UIImage(named: "cup-1")
        self.addSubview(cupImage)
        
        verticalScrollView = UIScrollView(frame: CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height + 8, width: self.frame.width - 24, height: 200))
        verticalScrollView.center.x = self.frame.width / 2
        verticalScrollView.isPagingEnabled = true
        verticalScrollView.showsHorizontalScrollIndicator = false
        verticalScrollView.contentSize = CGSize(width: self.verticalScrollView.frame.width, height: self.verticalScrollView.frame.height)
        self.addSubview(verticalScrollView)
        
        var testCard = IngredientNutritionCard(frame: CGRect(x: 0, y: 0, width: self.verticalScrollView.frame.width, height: self.verticalScrollView.frame.height))
        testCard.setNutritionalInformation(proteinVal: "12g", carbVal: "23g", fatVal: "14g")
        self.verticalScrollView.addSubview(testCard)
        
        shareButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 12, width: 30, height: 30))
        let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        shareButton.center.y = self.smoothieNameLabel.center.y
        self.addSubview(shareButton)
         

        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
