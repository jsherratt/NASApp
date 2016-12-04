//
//  APIClient.swift
//  LoL-Finder
//
//  Created by Joe Sherratt on 05/09/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

////-----------------------
////MARK: Properties
////-----------------------
public let SWNetworkingErrorDomain = "com.jsherratt.NASApp.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20

typealias JSON = [String : AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask

//-----------------------
//MARK: Enums
//-----------------------
enum APIResult<T> {
    
    case Success(T)
    case Failure(Error)
}

//-----------------------
//MARK: Protocols
//-----------------------
protocol JSONDecodable {
    
    init?(JSON: [String : AnyObject])
}

protocol Endpoint {
    
    var baseURL: String { get }
}

protocol APIClient {
    
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void)
}

//-----------------------
//MARK: Extensions
//-----------------------
extension APIClient {
    
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                
                //Show the user the network alert
                //NSNotificationCenter.defaultCenter().postNotificationName("NetworkAlert", object: nil)
                
                let error = NSError(domain: SWNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                
                return
            }
            
            if data == nil {
                
                if let error = error {
                    completion(nil, HTTPResponse, error as NSError?)
                }
                
            } else {
                
                switch HTTPResponse.statusCode {
                    
                case 200:
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
                        completion(json, HTTPResponse, nil)
                        
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                    
                default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        }
        
        return task
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        
        let task = JSONTaskWithRequest(request: request) { json, response, error in
            
            DispatchQueue.main.async {
                
                guard let json = json else {
                    
                    if let error = error {
                        completion(.Failure(error))
                        
                    } else {
                        
                    }
                    return
                }
                
                if let value = parse(json) {
                    completion(.Success(value))
                    
                } else {
                    
                    let error = NSError(domain: SWNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completion(.Failure(error))
                }
            }
        }
        
        task.resume()
    }
}

