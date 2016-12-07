//
//  ViewController.swift
//  NASApp
//
//  Created by Joey on 30/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import ContactsUI

class MainViewController: UIViewController {
    
    //-----------------------
    //MARK: Properties
    //-----------------------
    let nasaClient = NasaClient()
    let contactManager = ContactManager()
    let spaceImageProvider = SpaceImageProvider()
    var earthImage: EarthImage?
    fileprivate var messageView = UIView()
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spaceImageView: UIImageView!
    @IBOutlet weak var createRoverPostcardBtn: UIButton!
    @IBOutlet weak var eyeInTheSkyBtn: UIButton!
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navgationbar
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //Add notification observer to show earth image alert
        NotificationCenter.default.addObserver(self, selector: #selector(noEarthImageAlert), name: NSNotification.Name(rawValue: "EarthImageAlert"), object: nil)
        
        //Configure view
        configureView()
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    @IBAction func earthImageButtonTapped(_ sender: UIButton) {
        
        presentActionSheet()
    }
    
    func presentActionSheet() {
        
        let actionSheet = UIAlertController(title: "Search earth image for", message: nil, preferredStyle: .actionSheet)
        
        let contactAction = UIAlertAction(title: "A contact", style: .default) { contactAction in
            
            let contactsUI = CNContactPickerViewController()
            contactsUI.delegate = self
            
            contactsUI.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
            
            self.present(contactsUI, animated: true, completion: nil)
        }
        
        let addressAction = UIAlertAction(title: "An address", style: .default) { addressAction in
            
            let alert = UIAlertController(title: "Please enter an address", message: nil, preferredStyle: .alert)
            
            let searchAction = UIAlertAction(title: "Search", style: .default) { searchAction in
                let textField = alert.textFields!.first! as UITextField
                
                if let address = textField.text {
                    
                    self.activityIndicator.startAnimating()
                    
                    self.nasaClient.fetchEarthImage(for: address, completion: { result in
                        
                        switch result {
                            
                        case .Success(let image):
                            
                            self.earthImage = image
                            self.activityIndicator.stopAnimating()
                            self.performSegue(withIdentifier: "showEarthImage", sender: self)
                            
                        case .Failure(let error):
                            
                            self.showAlert(with: "Error", andMessage: error.localizedDescription)
                            self.activityIndicator.stopAnimating()
                        }
                    })
                }
            }
            searchAction.isEnabled = false
            
            alert.addTextField() {textField in
                textField.placeholder = "Enter address"
                NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) in
                    searchAction.isEnabled = textField.text != nil
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(searchAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(contactAction)
        actionSheet.addAction(addressAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    func configureView() {
        
        spaceImageView.image = spaceImageProvider.randomImage()
        
        //Configure buttons
        createRoverPostcardBtn.layer.cornerRadius = 5
        createRoverPostcardBtn.layer.masksToBounds = true
        eyeInTheSkyBtn.layer.cornerRadius = 5
        eyeInTheSkyBtn.layer.masksToBounds = true
        
        //Configure imageView
        spaceImageView.layer.cornerRadius = 7
        spaceImageView.layer.borderColor = UIColor.white.cgColor
        spaceImageView.layer.borderWidth = 2.5
        spaceImageView.layer.masksToBounds = true
    }
    
    //-----------------------
    //MARK: Navigation
    //-----------------------
    @objc func noEarthImageAlert() {
        
        self.activityIndicator.stopAnimating()
        
        //Cofigure message view color and to appear over the top of the navigation bar
        messageView.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)! + 100)
        self.navigationController?.navigationBar.addSubview(messageView)
        
        GSMessage.errorBackgroundColor = UIColor(red: 218.0/255, green: 75.0/255, blue: 75.0/255, alpha: 1.0)
        
        messageView.showMessage("Error\nNo earth image could be fetched", type: .error, options: [.textNumberOfLines(2),])
        
        delay(seconds: 3.3) {
            
            self.messageView.removeFromSuperview()
        }
    }
    
    //-----------------------
    //MARK: Navigation
    //-----------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEarthImage" {
            
            let earthVc = segue.destination as! EarthImageViewController
            
            earthVc.earthImage = self.earthImage
        }
    }
}

//------------------------------
//MARK: Contact Picker Delegate
//------------------------------
extension MainViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        self.activityIndicator.startAnimating()
        
        nasaClient.fetchEarthImage(for: contact, completion: { result in
        
            switch result {
                
            case .Success(let image):
                
                self.earthImage = image
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "showEarthImage", sender: self)
                
            case .Failure(let error):
                self.showAlert(with: "Error", andMessage: error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}






