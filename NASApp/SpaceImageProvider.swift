//
//  SpaceImageProvider.swift
//  NASApp
//
//  Created by Joey on 07/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import GameKit
import UIKit

struct SpaceImageProvider {
    
    let spaceImages: [UIImage] = [#imageLiteral(resourceName: "Space1"), #imageLiteral(resourceName: "Space2"), #imageLiteral(resourceName: "Space3"), #imageLiteral(resourceName: "Space4"), #imageLiteral(resourceName: "Space5")]
    
    func randomImage() -> UIImage {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: spaceImages.count)
        return spaceImages[randomNumber]
    }
}











































