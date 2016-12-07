//
//  EarthImageViewController.swift
//  NASApp
//
//  Created by Joey on 07/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import Nuke

class EarthImageViewController: UIViewController {
    
    //-----------------------
    //MARK: Properties
    //-----------------------
    var earthImage: EarthImage?
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEarthImage()
    }
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    func fetchEarthImage() {
        
        guard let image = earthImage, let imageUrl = image.imageUrl else { return }
        
        self.activityIndicator.startAnimating()
        
        Nuke.loadImage(with: imageUrl, into: imageView) { imageResponse, _ in
            
            if let image = imageResponse.value {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }else {
                self.showAlert(with: "Error", andMessage: "There was an error fetching the image")
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
