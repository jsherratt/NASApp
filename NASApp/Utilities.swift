//
//  Utilities.swift
//  ProximityReminders
//
//  Created by Joey on 24/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import MapKit

//---------------------
//MARK: Extensions
//---------------------
extension UIViewController {
    
    //Show alert with a title and message
    func showAlert(with title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

