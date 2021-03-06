//
//  RoverImageViewController.swift
//  NASApp
//
//  Created by Joey on 04/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class RoverImageViewController: UICollectionViewController {
    
    //-----------------------
    //MARK: Properties
    //-----------------------
    let nasaClient = NasaClient()
    var roverImages: [RoverImage]?

    //-----------------------
    //MARK: Properties
    //-----------------------
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRoverImages()
        
    }
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Fetch rover images from NASA API
    func fetchRoverImages() {
        
        activityIndicator.startAnimating()
        
        nasaClient.fetchRoverImages { result in
            
            switch result {
                
            case .Success(let images):
                
                self.activityIndicator.stopAnimating()
                
                self.roverImages = images
                self.collectionView?.reloadData()
                
            case .Failure(let error):
                
                self.activityIndicator.stopAnimating()
                print(error.localizedDescription)
                
            }
        }
    }
    
    //-----------------------
    //MARK: Navigation
    //-----------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRoverDetail" {
            
            let roverDetailVc = segue.destination as! RoverDetailViewController
            
            if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first {
                
                if let roverImage = self.roverImages?[indexPath.row] {
                    roverDetailVc.roverImage = roverImage
                }
            }
        }
    }

}

extension RoverImageViewController {
    
    //-----------------------
    //MARK: Collection View
    //-----------------------
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return roverImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RoverImageCell
        
        if let images = roverImages {
            
            let image = images[indexPath.row]
            cell.configureCell(with: image)
        }
        
        return cell
    }
}
