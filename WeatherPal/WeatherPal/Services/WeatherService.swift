//
//  WeatherService.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

// Weather Service: Class to handle api calls to the weather api
class WeatherService: NSObject {
    
    // Calls the weather api with given city name
    static func getWeather(lat : Double?, long : Double?, unitType : UnitType = .imperial, completed: @escaping (WeatherResponse) -> ()){
        
        // Create response variable to pass back to controller
        var weatherResponse = WeatherResponse()
        
        // Error check parameter
        if(lat == nil || long == nil){
            weatherResponse.status = ResponseStatuses.invalidInput
            completed(weatherResponse)
            return
        }
        
        // Create url and add query parameters
        var constructedUrl : String! = URLConstants.weatherUrl + "?"
        constructedUrl.append("lat=\(lat!)")
        constructedUrl.append("&lon=\(long!)")
        constructedUrl.append("&units=\(String(describing: unitType))")
        constructedUrl.append("&APPID=\(URLConstants.appId!)")
        
        guard let url = URL(string: constructedUrl) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add proper headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Call api
        let session = URLSession.shared
        session.dataTask(with: request){data, response, err in
            if(err != nil){
                print(err?.localizedDescription)
                // Error occurred
                weatherResponse.status = ResponseStatuses.networkError
                
            } else {
                
                // Successful call, try to map the json to weather object
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let response = jsonData as? [String:Any]{
                    weatherResponse.weather = Weather(response)
                    
                } else {
                    weatherResponse.status = ResponseStatuses.networkError
                }
            }
            completed(weatherResponse)
            return
        }.resume()
    }
}
