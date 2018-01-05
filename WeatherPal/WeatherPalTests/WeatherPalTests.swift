//
//  WeatherPalTests.swift
//  WeatherPalTests
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import XCTest
@testable import WeatherPal

class WeatherPalTests: XCTestCase {
    
    var savedCity:String? = "Jersey City"
    var lat:Double? = 40.7282
    var long:Double? = -74.0776
    
    override func setUp() {
        super.setUp()
        UserDefaultsUtilities.saveCity(savedCity!)
        UserDefaultsUtilities.saveLatLong(lat!, long!)
    }
    
    override func tearDown() {
        super.tearDown()
        
        savedCity = nil
        lat = nil
        long = nil
    }
    
    func testSavedCity() {
        let tempCity = UserDefaultsUtilities.getSavedCity()
        XCTAssertTrue(savedCity == tempCity)
    }
    
    func testLatLong(){
        let (tempLat, tempLong) = UserDefaultsUtilities.getLatLong()
        XCTAssertTrue(tempLat == lat)
        XCTAssertTrue(tempLong == long)
    }
    
    func testColors(){
        let redColor = 80.92834
        let orangeColor = 45.00
        let blueColor = 30.342
        
        XCTAssertTrue(WeatherUtilities.getColorFromDegreesF(redColor) == UIColor.red)
        XCTAssertTrue(WeatherUtilities.getColorFromDegreesF(orangeColor) == UIColor.orange)
        XCTAssertTrue(WeatherUtilities.getColorFromDegreesF(blueColor) == UIColor.blue)

    }
    
    
}
