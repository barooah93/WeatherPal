//
//  WeatherResponse.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

// Class to map the JSON response from the API call to our weather object
class WeatherResponse : NSObject {

    var status : Int! // Success by default
    var weather : Weather?
    
    init(_ status:Int) {
        self.status = status
    }
    
    convenience override init() {
        self.init(ResponseStatuses.success)
    }
    
}

// Weather object to hold valueable weather data
class Weather : NSObject {
    var weather : WeatherWeather?
    var main : MainWeather?
    var wind : WindWeather?
    
    // Initializer with json dictionary
    init(_ response : [String: Any]) {
        
        // Map nested weather object
        if let weatherObject = response["weather"] as? [Any] {
            let weatherTemp = WeatherWeather(weatherObject)
            self.weather = weatherTemp
        } else {
            print("Error mapping 'weather' in json")
        }
        
        
        // Map main object
        if let mainObject = response["main"] as? [String: Any] {
            let mainTemp = MainWeather(mainObject)
            self.main = mainTemp
        } else {
            print("Error mapping 'main' in json")
        }
        
        
        // Map wind object
        if let windObject = response["wind"] as? [String: Any] {
            let windTemp = WindWeather(windObject)
            self.wind = windTemp
        } else {
            print("Error mapping 'wind' in json")
        }
        
    }
    
    // Getter functions to abstract formatting
    func getTempFormatted() -> String{
        if self.main?.temp != nil {
            return String(Int(round(self.main!.temp!))).toDegrees()
        } else {
            return ""
        }
    }
    
    func getTempMaxFormatted() -> String {
        if self.main?.temp_max != nil {
            return "High \(String(Int(round(self.main!.temp_max!))).toDegrees())"
        } else {
            return ""
        }
    }
    
    func getTempMinFormatted() -> String {
        if self.main?.temp_min != nil {
            return "Low \(String(Int(round(self.main!.temp_min!))).toDegrees())"
        } else {
            return ""
        }
    }
    
    func getHumidityFormatted() -> String {
        if self.main?.humidity != nil {
            return "Humidity \(String(self.main!.humidity!)) %"
        } else {
            return ""
        }
    }
    
    func getPressureFormatted() -> String {
        if self.main?.pressure != nil {
            return "Pressure \(String(self.main!.pressure!))"
        } else {
            return ""
        }
    }
    
    func getWindSpeedFormatted() -> String {
        if self.wind?.speed != nil {
            return "Wind Speed \(String(self.wind!.speed!)) mph"
        } else {
            return ""
        }
    }
    
    func getDescriptionFormatted() -> String {
        if self.weather?.desc != nil && !self.weather!.desc!.isEmpty {
            return self.weather!.desc!.capitalized
        } else {
            return ""
        }
    }
}


// Lesser classes to help map the nested json objects in the response
class WeatherWeather : NSObject {
    var desc : String?
    var icon : String?
    
    init(_ weather: [Any]) {
        if(weather.count > 0){
            if let first = weather[0] as? [String:Any]{
                self.desc = first["description"] as? String
                self.icon = first["icon"] as? String
            }
        }
        
    }
}

class MainWeather : NSObject {
    var temp : Double?
    var humidity : Int?
    var pressure : Double?
    var temp_min : Double?
    var temp_max : Double?
    
    init(_ main: [String: Any]) {
        self.temp = main["temp"] as? Double
        self.humidity = main["humidity"] as? Int
        self.pressure = main["pressure"] as? Double
        self.temp_min = main["temp_min"] as? Double
        self.temp_max = main["temp_max"] as? Double
       
    }
    
    

    
}

class WindWeather : NSObject {
    var speed : Double?
    
    init(_ wind: [String: Any]){
        self.speed = wind["speed"] as? Double
    }
    
}

enum UnitType {
    case imperial
    case metric
}
