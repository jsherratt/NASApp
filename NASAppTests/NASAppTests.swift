//
//  NASAppTests.swift
//  NASAppTests
//
//  Created by Joey on 30/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import XCTest
@testable import NASApp
import Contacts

class NASAppTests: XCTestCase {
    
    //---------------------
    //MARK: Properties
    //---------------------
    let nasaClient = NasaClient()
    let geocoder = Geocoder()
    
    let correctFakeAddress = "London"
    let incorrectFakeAddress = "abcd"
    
    var fakeContact: CNMutableContact? = nil
    
    //-------------------------
    //MARK: Set up / Tear down
    //-------------------------
    override func setUp() {
        super.setUp()
        
        setUpFakeContact()
    }
    
    override func tearDown() {
        
        fakeContact = nil
        
        super.tearDown()
        
    }
    
    //Set up fake contact
    func setUpFakeContact() {
        
        fakeContact?.givenName = "John"
        fakeContact?.familyName = "Appleseed"
        
        let postalAddress = CNMutablePostalAddress()
        postalAddress.city = "London"
        postalAddress.country = "United Kingdom"
        
        let value: CNLabeledValue<CNPostalAddress> = CNLabeledValue(label: "Home", value: postalAddress)
        
        fakeContact?.postalAddresses = [value]
    }
    
    //------------------------
    //MARK: Rover Image Tests
    //------------------------
   
    
    //------------------------
    //MARK: Search Location
    //------------------------
    func testLocationSearchSuccess() {
        
        geocoder.geocodeAddress(for: correctFakeAddress) { location, _ in
            
            XCTAssertNil(location, "The address was not correct")
        }
    }
    
    func testLocationSearchFail() {
        
        geocoder.geocodeAddress(for: correctFakeAddress) { location, _ in
            
            XCTAssertNotNil(location, "The address was correct")
        }
    }
    
    //------------------------
    //MARK: Earth Image Tests - Location
    //------------------------
    func testFetchImageForAddressSuccess() {
        
        nasaClient.fetchEarthImage(for: correctFakeAddress) { result in
            
            switch result {
                
            case .Success( _):
                break
                
            case .Failure( _):
                XCTFail("Image could not be fetched")
            }
        }
    }
    
    func testFetchImageForAddressFail() {
        
        nasaClient.fetchEarthImage(for: incorrectFakeAddress) { result in
            
            switch result {
                
            case .Success( _):
                XCTFail("The address was correct")
                
            case .Failure( _):
                break
            }
        }
    }
    
    //------------------------
    //MARK: Earth Image Tests - Contact
    //------------------------
    func testFetchImageForContact() {
        
        if let contact = fakeContact {
            
            nasaClient.fetchEarthImage(for: contact) { result in
                
                switch result {
                    
                case .Success( _):
                    break
                    
                case .Failure( _):
                    XCTFail("Image could not be fetched")
                }
            }
        }
    }
    
    
}
