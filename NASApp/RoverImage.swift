//
//  RoverPhoto.swift
//  NASApp
//
//  Created by Joey on 04/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import Foundation
import UIKit

//-----------------------
//MARK: Protocol
//-----------------------
protocol Image {
    
    var imageUrl: URL? { get }
}

//-----------------------
//MARK: Structs
//-----------------------
struct RoverImage: Image {
    
    var imageUrl: URL?
    
    init?(json: [String : Any]) {
        
        guard let imageString = json["img_src"] as? String else { return nil }
        
        self.imageUrl = URL(string: imageString)
    }
}
