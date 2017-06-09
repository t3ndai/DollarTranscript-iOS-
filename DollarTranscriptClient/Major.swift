//
//  Major.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 6/7/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import Foundation


struct Major {
    
    var name : String = ""
    
    
}
extension Major {
    
    static let urlComponents = URLComponents(string: "https://adtdjvuzgt.localtunnel.me")
    static let session = URLSession(configuration: .default)
    
    init(json: [String: Any]) throws {
        
        guard let name = json["major"] as? String else { throw Serialization.missing("major") }
        
        self.name = name
    }
    
    
    func allMajors(completion: @escaping ([Major]) -> Void) {
        
        
        var majorsURLComponents = Major.urlComponents
        majorsURLComponents?.path = "/majors"
        
        
        do {
            
            
            if let majorsURL = majorsURLComponents?.url {
                
                
                Major.session.dataTask(with: majorsURL, completionHandler:  { (data,response, error)  in
                    
                    var majors = [Major]()
                    
                    if error != nil {
                        return
                    }
                    else if let data = data {
                        
                        let majorsJson = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]]
                        
                        
                        
                        majorsJson??.forEach{ major in

                            try? majors.append(Major(json: major))
                            
                        }
                        
                    }
                    
                    completion(majors)
                }).resume()
                
            }
            
        }
        
    }
}
