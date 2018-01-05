//
//  URLConstants.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

class URLConstants: NSObject {

    static var dev : String! = "http://api.openweathermap.org/data/2.5"
    static var stage : String! = ""
    static var prod : String! = ""
    
    static var appId : String! = "5ca8ceb67e78ec7bc4f2e09f35a62082"
    
    // Set environment here
    static var baseUrl : String! = dev
    
    static var weatherUrl : String! = baseUrl + "/weather"
    
    static var iconImageUrl : String! = "http://openweathermap.org/img/w/"
    
    
}
