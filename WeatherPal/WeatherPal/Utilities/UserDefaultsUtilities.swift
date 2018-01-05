//
//  UserDefaultsUtilities.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit
import Foundation

class UserDefaultsUtilities: NSObject {
    
    static var cityKey = "cityName"
    static var latKey = "latitude"
    static var longKey = "longitude"
    
    // Retrieve previously stored city name from user defaults, or nil if empty
    static func getSavedCity() -> String?{
        return UserDefaults.standard.value(forKey: cityKey) as? String
    }
    
    // Save city onto device
    static func saveCity(_ city: String){
        UserDefaults.standard.set(city, forKey: cityKey)
    }
    
    // Retrieve previously stored coordinates
    static func getLatLong() -> (Double?, Double?){
        let lat = UserDefaults.standard.value(forKey: latKey) as? Double
        let long = UserDefaults.standard.value(forKey: longKey) as? Double
        return (lat, long)
    }
    
    // Save city onto device
    static func saveLatLong(_ lat: Double, _ long: Double){
        UserDefaults.standard.set(lat, forKey: latKey)
        UserDefaults.standard.set(long, forKey: longKey)
    }
}
