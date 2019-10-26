//
//  ChartView.swift
//  
//
//  Created by Avi Arora on 10/26/19.
//

import UIKit
import Charts

class ChartView: UIViewController {
    
    var titleLabel: UILabel!
    var exitButton: UIButton!
    var ingredients: [String] = []
    var pieChartView: PieChartView!
    var smoothieName: String = ""
    
    var atAGlanceLabel: UILabel!
    
    var cholesterolLabel: UILabel!
    var sodiumLabel: UILabel!
    var fiberLabel: UILabel!
    var sugarLabel: UILabel!
    
    var cholesterolValue: UILabel!
    var sodiumValue: UILabel!
    var fiberValue: UILabel!
    var sugarValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: CGRect(x: 40, y: 12, width: self.view.frame.width - 80, height: 45))
        titleLabel.text = "Nutrition Facts"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.numberOfLines = 0
        titleLabel.contentMode = .scaleToFill
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        
        let foods = ["milk", "almonds", "banana", "whey"]
        let percentages = [40.0, 10.0, 30.0, 20.0]
        
        
        pieChartView = PieChartView(frame: CGRect(x: 0, y: 67, width: self.view.frame.width - 40, height: self.view.frame.width - 40))
        pieChartView.center.x = self.view.frame.width / 2
        setChart(dataPoints: foods, values: percentages)
        
        self.view.addSubview(pieChartView)
        
        exitButton = UIButton(frame: CGRect(x: 12, y: 12, width: 25, height: 25))
        exitButton.center.y = self.titleLabel.center.y
        let exitIcon = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        exitButton.setImage(exitIcon, for: .normal)
        exitButton.tintColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        self.view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(toMainViewController), for: .touchUpInside)
        
        let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "SIGN-UP-FOR-KEY"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/quickAnswer?q=How%20much%20vitamin%20c%20is%20in%202%20apples%3F")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
            }
        })

        dataTask.resume()
        
        var backgroundColor = UIView(frame: CGRect(x: 0, y: self.pieChartView.frame.origin.y + self.pieChartView.frame.height + 16, width: self.view.frame.width, height: self.view.frame.height - self.pieChartView.frame.height - titleLabel.frame.height))
        backgroundColor.backgroundColor = UIColor(red:0.91, green:0.52, blue:0.52, alpha:1.0)
        self.view.addSubview(backgroundColor)
        
        atAGlanceLabel = UILabel(frame: CGRect(x: 20, y: self.pieChartView.frame.origin.y + self.pieChartView.frame.width + 48, width: self.view.frame.width - 40 , height: 35))
        atAGlanceLabel.text = "Additional Info"
        atAGlanceLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        atAGlanceLabel.textColor = UIColor.white
        atAGlanceLabel.numberOfLines = 0
        atAGlanceLabel.contentMode = .scaleToFill
        atAGlanceLabel.textAlignment = .center
        self.view.addSubview(atAGlanceLabel)
        
        cholesterolLabel = UILabel(frame: CGRect(x: 20, y: self.pieChartView.frame.origin.y + self.pieChartView.frame.width + 108, width: (self.view.frame.width - 40) / 2, height: 30))
        cholesterolLabel.text = "Cholesterol"
        cholesterolLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        cholesterolLabel.textColor = UIColor.white
        cholesterolLabel.numberOfLines = 0
        cholesterolLabel.contentMode = .scaleToFill
        cholesterolLabel.textAlignment = .center
        self.view.addSubview(cholesterolLabel)
        
        cholesterolValue = UILabel(frame: CGRect(x: self.view.frame.width - (self.view.frame.width - 40) / 2, y: self.cholesterolLabel.frame.origin.y, width: (self.view.frame.width - 40) / 2, height: 30))
        cholesterolValue.text = "10 mg"
        cholesterolValue.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        cholesterolValue.textColor = UIColor.white
        cholesterolValue.numberOfLines = 0
        cholesterolValue.contentMode = .scaleToFill
        cholesterolValue.textAlignment = .center
        cholesterolValue.center.y = cholesterolLabel.center.y
        self.view.addSubview(cholesterolValue)
        
        sodiumLabel = UILabel(frame: CGRect(x: 20, y: self.cholesterolLabel.frame.origin.y + self.cholesterolLabel.frame.height + 12, width: (self.view.frame.width - 40) / 2, height: 30))
        sodiumLabel.text = "Sodium"
        sodiumLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        sodiumLabel.textColor = UIColor.white
        sodiumLabel.numberOfLines = 0
        sodiumLabel.contentMode = .scaleToFill
        sodiumLabel.textAlignment = .center
        self.view.addSubview(sodiumLabel)
        
        sodiumValue = UILabel(frame: CGRect(x: self.view.frame.width - (self.view.frame.width - 40) / 2, y: self.sodiumLabel.frame.origin.y, width: (self.view.frame.width - 40) / 2, height: 30))
        sodiumValue.text = "160 mg"
        sodiumValue.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        sodiumValue.textColor = UIColor.white
        sodiumValue.numberOfLines = 0
        sodiumValue.contentMode = .scaleToFill
        sodiumValue.textAlignment = .center
        sodiumValue.center.y = sodiumLabel.center.y
        self.view.addSubview(sodiumValue)
        
        
        fiberLabel = UILabel(frame: CGRect(x: 20, y: self.sodiumLabel.frame.origin.y + self.sodiumLabel.frame.height + 12, width: (self.view.frame.width - 40) / 2, height: 30))
        fiberLabel.text = "Fiber"
        fiberLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        fiberLabel.textColor = UIColor.white
        fiberLabel.numberOfLines = 0
        fiberLabel.contentMode = .scaleToFill
        fiberLabel.textAlignment = .center
        self.view.addSubview(fiberLabel)
        
        fiberValue = UILabel(frame: CGRect(x: self.view.frame.width - (self.view.frame.width - 40) / 2, y: self.fiberLabel.frame.origin.y, width: (self.view.frame.width - 40) / 2, height: 30))
        fiberValue.text = "4 g"
        fiberValue.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        fiberValue.textColor = UIColor.white
        fiberValue.numberOfLines = 0
        fiberValue.contentMode = .scaleToFill
        fiberValue.textAlignment = .center
        fiberValue.center.y = fiberLabel.center.y
        self.view.addSubview(fiberValue)
        
        sugarLabel = UILabel(frame: CGRect(x: 20, y: self.fiberLabel.frame.origin.y + self.fiberLabel.frame.height + 12, width: (self.view.frame.width - 40) / 2, height: 30))
        sugarLabel.text = "Sugar"
        sugarLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        sugarLabel.textColor = UIColor.white
        sugarLabel.numberOfLines = 0
        sugarLabel.contentMode = .scaleToFill
        sugarLabel.textAlignment = .center
        self.view.addSubview(sugarLabel)
        
        sugarValue = UILabel(frame: CGRect(x: self.view.frame.width - (self.view.frame.width - 40) / 2, y: self.sugarLabel.frame.origin.y, width: (self.view.frame.width - 40) / 2, height: 30))
        sugarValue.text = "12 g"
        sugarValue.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        sugarValue.textColor = UIColor.white
        sugarValue.numberOfLines = 0
        sugarValue.contentMode = .scaleToFill
        sugarValue.textAlignment = .center
        sugarValue.center.y = sugarLabel.center.y
        self.view.addSubview(sugarValue)
        
        
        
        
        
        
        
        
    }
    var dataEntries: [PieChartDataEntry] = []
    var pieChartDataSet: PieChartDataSet!
    var pieChartData: PieChartData!
    func setChart(dataPoints: [String], values: [Double]) {

        

        for i in 0 ..< dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            

            dataEntries.append(dataEntry1)
        }

        pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "\(smoothieName) Ingredients")
        pieChartDataSet.entryLabelFont = UIFont.systemFont(ofSize: 12, weight: .light)
        pieChartDataSet.entryLabelColor = UIColor.darkGray
        pieChartDataSet.valueColors = [UIColor.white]
        pieChartDataSet.valueFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        pieChartDataSet.colors = [ChartColorTemplates.colorFromString("#ff9a9e"), ChartColorTemplates.colorFromString("#fad0c4"), ChartColorTemplates.colorFromString("#ffecd2"), ChartColorTemplates.colorFromString("#fcb69f")]
        
        pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartView.rotationEnabled = false
        pieChartView.legend.enabled = false
        

    }

        
    override func viewWillAppear(_ animated: Bool) {
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func setSmoothieName(name: String) {
        smoothieName = name
    }
    
    @objc func toMainViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
