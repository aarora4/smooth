//
//  ViewController.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var smoothieView: SmoothieView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        smoothieView = SmoothieView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(smoothieView)
        smoothieView.summaryIcon.addTarget(self, action: #selector(connectViewTransition), for: .touchUpInside)
    }
    @objc func connectViewTransition() {
        let chartView = ChartView()
        chartView.modalPresentationStyle = .fullScreen
        chartView.setSmoothieName(name: smoothieView.smoothieNameLabel.text ?? "")
        self.present(chartView, animated: true, completion: nil)
    }


}

