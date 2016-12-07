//
//  EarthImage.swift
//  NASApp
//
//  Created by Joey on 07/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import Foundation

//-----------------------
//MARK: Structs
//-----------------------
struct EarthImage: Image {
    
    var imageUrl: URL?
    
    init?(json: [String : Any]) {
        
        guard let imageString = json["url"] as? String else { return nil }
        
        self.imageUrl = URL(string: imageString)
    }
}
