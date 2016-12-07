//
//  FactProvider.swift
//  FunFacts
//
//  Created by Screencast on 11/2/16.
//  Copyright © 2016 Treehouse Island. All rights reserved.
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











































