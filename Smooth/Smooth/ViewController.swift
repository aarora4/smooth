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
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        smoothieView = SmoothieView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(smoothieView)
    }


}

