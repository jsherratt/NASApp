//
//  RoverImageCell.swift
//  NASApp
//
//  Created by Joey on 04/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import Nuke

class RoverImageCell: UICollectionViewCell {
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var imageView: UIImageView!

    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Configure each cell with image loaded using nuke
    func configureCell(with image: RoverImage) {
        
        self.layer.cornerRadius = 7
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.5
        self.layer.masksToBounds = true
        
        if let url = image.imageUrl {
            
            Nuke.loadImage(with: url, into: imageView)
        }
    }
    
}
