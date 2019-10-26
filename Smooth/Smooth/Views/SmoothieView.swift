//
//  SmoothieView.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit

class SmoothieView: UIView, UIScrollViewDelegate {
    
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
    var summaryIcon: UIButton!
    

    func setupView() {
        
        smoothieNameLabel = UITextField(frame: CGRect(x: 0, y: 12, width: 300, height: 45))
        smoothieNameLabel.attributedPlaceholder = NSAttributedString(string: "My Smoothie",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        smoothieNameLabel.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        smoothieNameLabel.textColor = UIColor.darkGray
        
        smoothieNameLabel.contentMode = .scaleToFill
        smoothieNameLabel.textAlignment = .center
        smoothieNameLabel.center.x = self.frame.width / 2
//        smoothieNameLabel.alpha = 0
        self.addSubview(smoothieNameLabel)
        
        
        totalCalories = UILabel(frame: CGRect(x: 0, y: self.smoothieNameLabel.frame.origin.y + self.smoothieNameLabel.frame.height + 2, width: 200, height: 25))
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
        
        verticalScrollView = UIScrollView(frame: CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height + 8, width: self.frame.width, height: 180))
        verticalScrollView.center.x = self.frame.width / 2
        verticalScrollView.isPagingEnabled = true
        verticalScrollView.showsHorizontalScrollIndicator = false
        verticalScrollView.contentSize = CGSize(width: self.verticalScrollView.frame.width * 2, height: self.verticalScrollView.frame.height)
        verticalScrollView.delegate = self
        self.addSubview(verticalScrollView)
        
        var testCard = IngredientNutritionCard(frame: CGRect(x: 0, y: 0, width: self.verticalScrollView.frame.width - 24, height: self.verticalScrollView.frame.height))
        testCard.center.x = self.verticalScrollView.frame.width / 2
        testCard.setNutritionalInformation(proteinVal: "12g", carbVal: "23g", fatVal: "14g")
        self.verticalScrollView.addSubview(testCard)
        
        var testCard2 = IngredientNutritionCard(frame: CGRect(x: self.verticalScrollView.frame.width + 12, y: 0, width: self.verticalScrollView.frame.width - 24, height: self.verticalScrollView.frame.height))
//        testCard2.center.x = self.verticalScrollView.frame.width / 2
        testCard2.setTitle(text: "banana")
        testCard2.setNutritionalInformation(proteinVal: "11g", carbVal: "24g", fatVal: "13g")
        self.verticalScrollView.addSubview(testCard2)
        
        shareButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 12, width: 25, height: 25))
        let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        shareButton.center.y = self.smoothieNameLabel.center.y
        self.addSubview(shareButton)
        
        summaryIcon = UIButton(frame: CGRect(x: 10, y: 12, width: 30, height: 30))
        let summaryImage = UIImage(named: "head")?.withRenderingMode(.alwaysTemplate)
        summaryIcon.setImage(summaryImage, for: .normal)
        summaryIcon.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        summaryIcon.center.y = self.smoothieNameLabel.center.y
        self.addSubview(summaryIcon)
        
        
        var testIngredient = IngredientSegmentView(frame: CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height - 123 - 30, width: 200, height: 30))
        testIngredient.center.x = self.frame.width / 2
        testIngredient.setTitle(text: "blueberries")
        testIngredient.setBackgroundColor(hex: UIColor(red:0.22, green:0.33, blue:0.56, alpha:1.0))
        testIngredient.setIdentifier(identifier: 0)
        testIngredient.toggleSelected()
        self.addSubview(testIngredient)
        self.sendSubviewToBack(testIngredient)
        
        var testIngredient2 = IngredientSegmentView(frame: CGRect(x: 0, y: testIngredient.frame.origin.y - 35, width: 250, height: 35))
        testIngredient2.center.x = self.frame.width / 2
        testIngredient2.setTitle(text: "banana")
        testIngredient2.setIdentifier(identifier: 1)
        testIngredient2.setBackgroundColor(hex: UIColor(red:1.00, green:0.83, blue:0.32, alpha:1.0))

        testIngredient2.toggleSelected()
        
        
        self.ingredients.append(testIngredient)
        self.ingredients.append(testIngredient2)
        self.ingredientCards.append(testCard)
        self.ingredientCards.append(testCard2)
        
        
        self.addSubview(testIngredient2)
        self.sendSubviewToBack(testIngredient2)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: verticalScrollView.frame.height + verticalScrollView.frame.origin.y - 32, width: verticalScrollView.frame.width, height: 30))
       pageControl.numberOfPages = 3
       pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.7)
       pageControl.currentPage = 0
       pageControl.currentPageIndicatorTintColor = .gray
        
//       self.addSubview(pageControl)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = verticalScrollView.contentOffset.x / verticalScrollView.frame.size.width
        let identifier = Int(round(value))
        for i in 0 ..< self.ingredients.count {
            if (self.ingredients[i].selected) {
                self.ingredients[i].toggleSelected()
            }
        }
        self.ingredients[identifier].toggleSelected()
        
        
        
    }
    
    func setCalories(calories: String) {
        self.totalCalories.text = "\(calories) + Calories"
    }

}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
