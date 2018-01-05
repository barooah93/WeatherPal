//
//  BaseViewController.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var loadingOverlay: UIView?
    var loadingTextLabel: UILabel?
    var loadingFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingFrame = self.view.frame
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update frame
        loadingFrame = self.view.frame
    }

    override func viewWillDisappear(_ animated: Bool) {
        HideLoadingOverlay()
    }
    
    // Function to present a loading overlay while calling for data
    func PresentLoadingOverlay(title: String=""){
        if(loadingOverlay == nil){
            loadingOverlay = UIView(frame: self.loadingFrame!)
            loadingOverlay?.isHidden = false
            loadingOverlay?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            
            
            if(!title.isEmpty){
                loadingTextLabel = UILabel(frame: CGRect(x: (loadingOverlay?.center.x)!-((loadingOverlay?.frame.width)!/2),
                                                         y: (loadingOverlay?.center.y)!,
                                                         width: (loadingOverlay?.frame.width)!,
                                                         height: 20))
                loadingTextLabel?.text = title
                loadingTextLabel?.textAlignment = .center
                loadingTextLabel?.textColor = UIColor.white
                loadingTextLabel?.center.x = (loadingOverlay?.center.x)!
                loadingTextLabel?.center.y = (loadingOverlay?.center.y)!
                loadingOverlay?.addSubview(loadingTextLabel!)
            }
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.center = (self.loadingOverlay?.center)!
            activityIndicator.frame.origin.y += 20
            activityIndicator.startAnimating()
            self.loadingOverlay?.addSubview(activityIndicator)
            
            self.view.addSubview(self.loadingOverlay!)
        } else {
            DispatchQueue.main.async {
                self.loadingTextLabel?.text = title
            }
        }
    }
    
    // Function to hide the loading overlay
    func HideLoadingOverlay(){
        if (self.loadingOverlay != nil) {
            DispatchQueue.main.async {
                self.loadingOverlay?.isHidden = true
                self.loadingOverlay?.removeFromSuperview()
                self.loadingOverlay = nil
            }
        }
        
    }
}
