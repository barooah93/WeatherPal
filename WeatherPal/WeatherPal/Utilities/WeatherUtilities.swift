//
//  WeatherUtilities.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/10/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

class WeatherUtilities: NSObject {

    // Takes in degrees in fahrenheit and returns a UI color appropriately
    static func getColorFromDegreesF(_ degrees: Double) -> UIColor {
        if(round(degrees) >= 80){
            return UIColor.red
        }
        if(round(degrees) >= 45) {
            return UIColor.orange
        }
        return UIColor.blue
    }
}
