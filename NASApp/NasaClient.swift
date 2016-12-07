//
//  RiotClient.swift
//  LoL-Finder
//
//  Created by Joe Sherratt on 05/09/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation
import Contacts

//-----------------------
//MARK: Enums
//-----------------------
enum ImageDatabase: Endpoint {
    
    case curiosityImages
    case earth
    
    var baseURL: String {
        return "https://api.nasa.gov/"
    }
    
    private var apiKey: String {
        
        return "64B48lgztNXBsmvfnJfWRJaMjKrPgepTXRLTOzvA"
        
    }
    
    func createUrl(with parameters: [String : Any]?) -> URL? {
        
        switch self {
            
        case .curiosityImages:
            
            return URL(string: baseURL + "mars-photos/api/v1/rovers/curiosity/photos?&sol=1000&api_key=\(apiKey)")
            
        case .earth:
            
            guard let params = parameters, let latitude = params["latitude"] as? Double, let longitude = params["longitude"] as? Double else { return nil }
            
            return URL(string: baseURL + "planetary/earth/imagery?lat=\(latitude)&lon=\(longitude)&api_key=\(apiKey)")
        }
    }
}

//-----------------------
//MARK: Classes
//-----------------------
final class NasaClient: APIClient {
    
    let geoCoder = Geocoder()
    let contactManager = ContactManager()
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: URLSessionConfiguration.default)
    }
    
    //-----------------------
    //MARK: Images
    //-----------------------
    
    //Fetch rover images
    func fetchRoverImages(completion: @escaping (APIResult<[RoverImage]>) -> Void) {
        
        guard let url = ImageDatabase.curiosityImages.createUrl(with: nil) else { return }
        
        let request = URLRequest(url: url)
        
        fetch(request: request, parse: { json -> [RoverImage]? in
            
            if let images = json["photos"] as? [[String : Any]] {
                
                return images.flatMap { imageDict in
                    
                   return RoverImage(json: imageDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    //Fetch earth image for address
    func fetchEarthImage(for address: String, completion: @escaping (APIResult<EarthImage>) -> Void) {
        
        geoCoder.geocodeAddress(for: address) { location, error in
         
            guard let location = location else { return }
            
            guard let url = ImageDatabase.earth.createUrl(with: ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]) else { return }
            
            let request = URLRequest(url: url)
            
            self.fetch(request: request, parse: { json -> EarthImage? in
                
                let imageDict = json
                
                return EarthImage(json: imageDict)
                
            }, completion: completion)
            
        }
    }
    
    //Fetch earth image for contact
    func fetchEarthImage(for contact: CNContact, completion: @escaping (APIResult<EarthImage>) -> Void) {
        
        contactManager.searchLocation(for: contact, completion: { location, error in
            
            guard let location = location else { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EarthImageAlert"), object: nil); return }
                        
            guard let url = ImageDatabase.earth.createUrl(with: ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]) else { return }
            
            let request = URLRequest(url: url)
            
            self.fetch(request: request, parse: { json -> EarthImage? in
                
                let imageDict = json
                
                return EarthImage(json: imageDict)
                
            }, completion: completion)
        })
    }

}
