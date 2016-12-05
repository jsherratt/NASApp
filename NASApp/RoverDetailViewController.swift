//
//  RoverViewController.swift
//  NASApp
//
//  Created by Joey on 04/12/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import MessageUI
import CoreGraphics
import Nuke

class RoverDetailViewController: UIViewController {
    
    //-----------------------
    //MARK: Properties
    //-----------------------
    var roverImage: RoverImage?
    var image = UIImage()
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure imageView
        configureImageView(with: roverImage)

    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    
    //Add text button tapped
    @IBAction func addText(_ sender: UIButton) {
        
        addTextAlertController()
    }
    
    //Email button tapped
    @IBAction func emailPostcard(_ sender: UIButton) {
        
        emailPostcard()
    }
    
    //-----------------------
    //MARK: Functions
    //-----------------------
    
    //Configure the imageView with the rover image
    func configureImageView(with image: RoverImage?) {
        
        if let imageUrl = image?.imageUrl {
            
            Nuke.loadImage(with: imageUrl, into: imageView) { imageResponse, _ in
                
                if let image = imageResponse.value {
                    self.imageView.image = image
                    self.image = image
                }
            }
        }
        
        imageView.layer.cornerRadius = 7
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.5
        imageView.layer.masksToBounds = true
    }
    
    //Add text alert controller logic
    func addTextAlertController() {
        
        let alert = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { doneAction in
            
            let textField = (alert.textFields?.first)! as UITextField
            
            if let text = textField.text {
                
                UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseInOut, animations: {
                    
                    self.previewView.alpha = 1.0
                    
                }, completion: nil)
                
                let newImage = self.textToImage(drawText: text, inImage: self.image)
                self.previewImage.image = newImage
                
                self.previewImage.layer.cornerRadius = 7
                self.previewImage.layer.borderColor = UIColor.white.cgColor
                self.previewImage.layer.borderWidth = 2.5
                self.previewImage.layer.masksToBounds = true
            }
        }
        
        doneAction.isEnabled = false
        
        alert.addTextField() { textField in
            
            textField.placeholder = "Greetings from Mars"
            NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) in
                
                doneAction.isEnabled = textField.text != nil
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Email controller logic
    func emailPostcard() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            if let imageData = UIImageJPEGRepresentation(self.image, 1.0) {
                composeVC.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "\(imageData.description)")
            }
            
            self.present(composeVC, animated: true, completion: nil)
            
        } else {
            showAlert(with: "Error", andMessage: "Seems like your device doesn't support sending e-mails, or you're not logged in.")
            return
        }
    }
    
    //Adds texts to the image
    func textToImage(drawText text: String, inImage image: UIImage) -> UIImage {
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica", size: 24)!
        
        UIGraphicsBeginImageContext(image.size)
        
        let textFontAttributes = [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: CGPoint(x: 30, y: image.size.height - 50), size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

//----------------------------
//MARK: Mail Compose Delegate
//----------------------------
extension RoverDetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
















