//
//  RiotClient.swift
//  LoL-Finder
//
//  Created by Joe Sherratt on 05/09/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

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
            
            return URL(string: baseURL + "planetary/earth/imagery?api_key=\(apiKey)&lat=\(latitude)&lon=\(longitude)")
        }
    }
}

//-----------------------
//MARK: Classes
//-----------------------
final class NasaClient: APIClient {
    
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
        
        print(url)
        
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

}