//
//  Geocoder.swift
//  NASApp
//
//  Created by Dennis Parussini on 20-11-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import CoreLocation

struct Geocoder {
    
    //-----------------------
    //MARK: Properties
    //-----------------------
    let geoCoder = CLGeocoder()
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Get address from string
    func geocodeAddress(for addressString: String, completion: @escaping (CLLocation?, Error?) -> Void) {
        
        geoCoder.geocodeAddressString(addressString) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
