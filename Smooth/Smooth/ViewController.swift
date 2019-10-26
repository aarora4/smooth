//
//  ViewController.swift
//  Smooth
//
//  Created by Avi Arora on 10/25/19.
//  Copyright © 2019 Avi Arora. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FacebookCore

class ViewController: UIViewController, SharingDelegate {
    var smoothieView: SmoothieView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        smoothieView = SmoothieView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(smoothieView)
        smoothieView.summaryIcon.addTarget(self, action: #selector(connectViewTransition), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shareToFacebook), name: NSNotification.Name("didPressShare"), object: nil)
        
        
    }
    @objc func connectViewTransition() {
        let chartView = ChartView()
        chartView.modalPresentationStyle = .fullScreen
        chartView.setSmoothieName(name: smoothieView.smoothieNameLabel.text ?? "")
        self.present(chartView, animated: true, completion: nil)
    }
    
    @objc func shareToFacebook() {
         
         let shareContent = ShareLinkContent()
         shareContent.contentURL = URL.init(string: "https://github.com/aarora4/smooth")! //your link
        shareContent.quote = "My Smoothie: \n  \(smoothieView.ingredients[0].nameLabel.text ?? "ingredient 1") => 326g\n  \(smoothieView.ingredients[0].nameLabel.text ?? "ingredient 2") => 106g\n  \(smoothieView.ingredients[0].nameLabel.text ?? "ingredient 3") => 13g\n    \(smoothieView.ingredients[0].nameLabel.text ?? "ingredient 4") => 24g\n  "
         ShareDialog(fromViewController: self, content: shareContent, delegate: self).show()
    
     }
     
     func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
         if sharer.shareContent.pageID != nil {
             print("Share: Success")
         }
     }
     func sharer(_ sharer: Sharing, didFailWithError error: Error) {
         print("Share: Fail")
     }
     func sharerDidCancel(_ sharer: Sharing) {
         print("Share: Cancel")
     }


}

