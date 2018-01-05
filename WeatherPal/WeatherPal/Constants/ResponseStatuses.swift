//
//  ResponseStatuses.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

class ResponseStatuses: NSObject {

    static var invalidInput = -1
    static var success = 0
    static var networkError = 400
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
    case generic()
}
