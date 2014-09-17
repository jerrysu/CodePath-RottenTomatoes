//
//  RottenTomatoesApi.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/16/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

struct RottenTomatoesApi {
    static var API_BASE = "http://api.rottentomatoes.com/api/public/v1.0"
    static var API_KEY = "yz8aght3p6b47r22wmkyezan"

    static func getEndpointURL(endpoint: RottenTomatoesEndpoint) -> NSURL {
        return NSURL(string: "\(API_BASE)\(endpoint.toRaw())?limit=50&apikey=\(API_KEY)")
    }
}

enum RottenTomatoesEndpoint: NSString {
    case BoxOffice = "/lists/movies/box_office.json"
    case TopRentals = "/lists/dvds/top_rentals.json"
}
