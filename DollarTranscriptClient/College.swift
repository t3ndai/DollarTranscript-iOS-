//
//  College.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 6/7/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import Foundation


struct College {
    
    var name : String = ""
    var average: String = ""
}
extension College {
    
    static let urlComponents = URLComponents(string: "http://pathele.com") //"http://104.131.14.43"
    static let session = URLSession(configuration: .default)
    
    init(json: [String: Any]) throws {
        
        guard let name = json["college"] as? String else { throw Serialization.missing("college") }
        guard let average = json["average"] as? String else { throw Serialization.missing("average") }
        
        self.name = name
        self.average = average
    }
    
    func allColleges(completion: @escaping ([College]) -> Void) {
        
        
        var collegesURLComponents = College.urlComponents
        collegesURLComponents?.path = "/colleges"
        
        
        do {
            
            
            if let collegesURL = collegesURLComponents?.url {
                
                
                Major.session.dataTask(with: collegesURL, completionHandler:  { (data,response, error)  in
                    
                    var colleges = [College]()
                    
                    if error != nil {
                        return
                    }
                    else if let data = data {
                        
                        let collegesJson = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]]
                        
                        
                        
                        collegesJson??.forEach{ college in
                            
                            try? colleges.append(College(json: college))
                            
                        }
                        
                    }
                    
                    completion(colleges)
                }).resume()
                
            }
            
        }

    }
    
    
}
