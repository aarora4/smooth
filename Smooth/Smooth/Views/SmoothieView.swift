//
//  SmoothieView.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FacebookCore
import Alamofire
import SwiftyJSON

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
    var itemsList: [String] = []
    var totalWeightGrams: Double = 0.0
    var totalCalories: UILabel!
    var editIcon: UIImageView!
    var pageControl: UIPageControl!
    var summaryIcon: UIButton!
    var colors: [UIColor] = [UIColor(red:1.00, green:0.83, blue:0.32, alpha:1.0), UIColor(red:0.31, green:0.65, blue:0.76, alpha:1.0), UIColor(red:0.68, green:0.33, blue:0.54, alpha:1.0), UIColor(red:0.29, green:0.76, blue:0.60, alpha:1.0)]
    
    var totalHeight: Double = 177.0
    var caloricTotal: Int = 0
    var timer: Timer? = nil
    
    @objc func checkUpdates() {
        AF.request("https://DelishAppNCR.pythonanywhere.com/active/appUpdate", method: .get,  parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let serviceAvailability = json["serviceAvailable"] as! Bool
                        let update = json["update"]
                        let updateAvailability = json["updateAvailable"] as! Bool
                        
                        if (serviceAvailability && updateAvailability) {
                            let items = update as! [String : Double]
                            print(items)
                            for item in items.keys {
                                print(item)
                                print(self.itemsList.firstIndex(of: item))
                                if (self.itemsList.firstIndex(of: item) == nil) {
                                    print("here!!!")
                                    if (items[item]! > 0.0) {
                                        let newIngredient = IngredientSegmentView(frame: CGRect(x: 0, y: 0, width: 236, height: 100))
                                        let colorIndex = Int(arc4random_uniform(UInt32(self.colors.count)))
                                        
                                        newIngredient.setBackgroundColor(hex:self.colors[colorIndex])
                                        self.colors.remove(at: colorIndex)
                                        newIngredient.weight = items[item]!
                                        
                                        newIngredient.setIdentifier(identifier: self.itemsList.count)
                                        newIngredient.nameLabel.text = "\(item)"
                                        newIngredient.toggleSelected()
                                        self.totalWeightGrams += items[item]!
                                        self.updateSegments(newIngredient: newIngredient)
                                        self.itemsList.append(item)
                                        
                                        self.getNutritonalInformation(food: "\(items[item]!)g of \(item)", name: item, weight: "\(items[item]!)")
                                    }
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                    }
                case .failure(let error):
                    print(error)
//                    print("here2")
                }
                
        }
    }

    func setupView() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkUpdates), userInfo: nil, repeats: true)
        
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
        totalCalories.text = "0 Calories"
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
        verticalScrollView.contentSize = CGSize(width: self.verticalScrollView.frame.width, height: self.verticalScrollView.frame.height)
        verticalScrollView.delegate = self
        self.addSubview(verticalScrollView)
        
        var testCard = IngredientNutritionCard(frame: CGRect(x: 0, y: 0, width: self.verticalScrollView.frame.width - 24, height: self.verticalScrollView.frame.height))
        testCard.center.x = self.verticalScrollView.frame.width / 2
        testCard.setNutritionalInformation(proteinVal: "0.0g", carbVal: "0.0g", fatVal: "0.0g")
        testCard.setTitle(text: "ice")
        
        self.verticalScrollView.addSubview(testCard)
        
        self.ingredientCards.append(testCard)
        
//        var testCard2 = IngredientNutritionCard(frame: CGRect(x: self.verticalScrollView.frame.width + 12, y: 0, width: self.verticalScrollView.frame.width - 24, height: self.verticalScrollView.frame.height))
////        testCard2.center.x = self.verticalScrollView.frame.width / 2
//        testCard2.setTitle(text: "banana")
//        testCard2.setNutritionalInformation(proteinVal: "11g", carbVal: "24g", fatVal: "13g")
//        self.verticalScrollView.addSubview(testCard2)
        
        shareButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 12, width: 25, height: 25))
        let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        shareButton.center.y = self.smoothieNameLabel.center.y
        self.addSubview(shareButton)
        
        shareButton.addTarget(self, action: #selector(triggerNotification), for: .touchUpInside)
        
        summaryIcon = UIButton(frame: CGRect(x: 10, y: 12, width: 30, height: 30))
        let summaryImage = UIImage(named: "head")?.withRenderingMode(.alwaysTemplate)
        summaryIcon.setImage(summaryImage, for: .normal)
        summaryIcon.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        summaryIcon.center.y = self.smoothieNameLabel.center.y
        self.addSubview(summaryIcon)
        
        
        var testIngredient = IngredientSegmentView(frame: CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height - 123 - 177, width: 236, height: 177))
        testIngredient.center.x = self.frame.width / 2
        testIngredient.setTitle(text: "ice")
        testIngredient.setBackgroundColor(hex: UIColor(red:0.22, green:0.33, blue:0.56, alpha:1.0))
        testIngredient.setIdentifier(identifier: 0)
        testIngredient.toggleSelected()
        testIngredient.setWeight(grams: 10.0)
        totalWeightGrams += 10.0
        self.addSubview(testIngredient)
        self.sendSubviewToBack(testIngredient)
        self.ingredients.append(testIngredient)
        
//        var testIngredient2 = IngredientSegmentView(frame: CGRect(x: 0, y: testIngredient.frame.origin.y - 35, width: 250, height: 35))
//        testIngredient2.center.x = self.frame.width / 2
//        testIngredient2.setTitle(text: "banana")
//        testIngredient2.setIdentifier(identifier: 1)
//        testIngredient2.setWeight(grams: 17.0)
//        totalWeightGrams += 17.0
//        testIngredient2.setBackgroundColor(hex: UIColor(red:1.00, green:0.83, blue:0.32, alpha:1.0))
//
//        testIngredient2.toggleSelected()
        
        
//        updateSegments(newIngredient: testIngredient2)
        
        
        
//        self.ingredients.append(testIngredient2)

//        self.ingredientCards.append(testCard2)
        
        
//        self.addSubview(testIngredient2)
//        self.sendSubviewToBack(testIngredient2)
        
       pageControl = UIPageControl(frame: CGRect(x: 0, y: verticalScrollView.frame.height + verticalScrollView.frame.origin.y - 32, width: verticalScrollView.frame.width, height: 30))
       pageControl.numberOfPages = 3
       pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.7)
       pageControl.currentPage = 0
       pageControl.currentPageIndicatorTintColor = .gray
        
//        self.getNutritonalInformation(food: "80g of banana")
        
        
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
    
    @objc func triggerNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didPressShare"), object: nil, userInfo: nil)
    }
    
    func updateSegments(newIngredient: IngredientSegmentView?) {
        
        //change total weight before this function is called
        for i in 0 ..< ingredients.count {
            var percentage = ingredients[i].weight / totalWeightGrams
            var viewHeight = totalHeight * percentage
            UIView.animate(withDuration: 0.2) {
                if (i == 0 ){
//                    self.ingredients[i].frame = CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height - 123 - Int(viewHeight), width: 236, height: Int(viewHeight))
                    self.ingredients[i].frame = CGRect(x: 0, y: self.cupImage.frame.origin.y + self.cupImage.frame.height - 123 - CGFloat(viewHeight), width: 236, height: CGFloat(viewHeight))
                    self.ingredients[i].center.x = self.frame.width / 2
                    self.ingredients[i].nameLabel.center.x = self.ingredients[i].frame.width / 2
                    self.ingredients[i].nameLabel.center.y = self.ingredients[i].frame.height / 2
                    
                } else {
                    self.ingredients[i].frame = CGRect(x: 0, y: self.ingredients[i - 1].frame.origin.y - CGFloat(viewHeight), width: 236, height: CGFloat(viewHeight))
                    self.ingredients[i].center.x = self.frame.width / 2
                    self.ingredients[i].nameLabel.center.x = self.ingredients[i].frame.width / 2
                    self.ingredients[i].nameLabel.center.y = self.ingredients[i].frame.height / 2
                }
            }
        }
        if (newIngredient != nil) {
            var percentage = newIngredient!.weight / totalWeightGrams
            var viewHeight = totalHeight * percentage
            
//            UIView.animate(withDuration: 0.2) {
                newIngredient?.frame = CGRect(x: 0, y: self.ingredients[self.ingredients.count - 1].frame.origin.y - CGFloat(viewHeight), width: 236, height: CGFloat(viewHeight))
                newIngredient!.center.x = self.frame.width / 2
                newIngredient!.nameLabel.center.x = newIngredient!.frame.width / 2
                newIngredient!.nameLabel.center.y = newIngredient!.frame.height / 2
//            }
            
            self.ingredients.append(newIngredient!)
            self.addSubview(newIngredient!)
            self.sendSubviewToBack(newIngredient!)
        }
        
        

    }
    
    func getNutritonalInformation(food: String, name: String, weight: String) {
        
        
        let foodName = food
        let appId = "128a0b75"
        let appKey = "b16ca21134c4da32cf34b2b4069be6bf"
        
        let url = "https://trackapi.nutritionix.com/v2/natural/nutrients"
        
        let headers: HTTPHeaders = [
            "x-app-id": "128a0b75",
            "x-app-key": "b16ca21134c4da32cf34b2b4069be6bf",
            "x-remote-user-id": "0",
            "Content-Type": "application/json"
        ]
        
        
        AF.request(url, method: .post, parameters: ["query":food],encoding: JSONEncoding.default, headers: headers).responseJSON {
         response in
            switch response.result {
            case .success(let value):
                do {
                    let json = value as! [String:Any]
//                    print(json)
                    if let foods = json["foods"] as? [[String : Any]] {
                        print(foods[0].keys)
                        print(foods[0]["nf_calories"])
                        print(foods[0]["nf_total_carbohydrate"])
                        print(foods[0]["nf_protein"])
                        print(foods[0]["nf_total_fat"])
                        
                        DispatchQueue.main.async {
                            var testCard2 = IngredientNutritionCard(frame: CGRect(x: (self.verticalScrollView.frame.width * CGFloat(self.ingredientCards.count)) + 12, y: 0, width: self.verticalScrollView.frame.width - 24, height: self.verticalScrollView.frame.height))
//                                    testCard2.center.x = self.verticalScrollView.frame.width / 2
                                    testCard2.setTitle(text: name)
                                    testCard2.setNutritionalInformation(proteinVal: "\(foods[0]["nf_protein"]!)g", carbVal: "\(foods[0]["nf_total_carbohydrate"]!)g", fatVal: "\(foods[0]["nf_total_fat"]!)g")
                            self.ingredientCards.append(testCard2)
                            self.verticalScrollView.contentSize = CGSize(width: (self.frame.width * CGFloat(self.ingredientCards.count)), height: 180)
                            self.verticalScrollView.addSubview(testCard2)
                            self.verticalScrollView.setContentOffset(CGPoint(x: self.frame.width * CGFloat(self.ingredientCards.count - 1), y: 0), animated: true)
                            let calories = foods[0]["nf_calories"]! as! NSNumber
                            self.caloricTotal += Int(calories)
                            testCard2.setWeight(weight: weight)
                            
                            self.setTotalCalories()
                        }
                        
                    }
                    
                } catch {
                    print("JSONSerialization error:", error)
                }
                
                
                
                
                break
                
            case .failure(let error):
                print(error)
                break
            }
        
        }
        
        
        
    }
    
    func setTotalCalories() {
        totalCalories.text = "\(caloricTotal) Calories"
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
