//
//  Area.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 6/7/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import Foundation


struct Area {
    
    var name: String = ""
    var average: String = ""
    
}
extension Area {
    
    static let urlComponents = URLComponents(string: "http://pathele.com")
    static let session = URLSession(configuration: .default)

    init(json: [String: Any]) throws {
        
        guard let name = json["location"] as? String else { throw Serialization.missing("location") }
        guard let average = json["average"] as? String else { throw Serialization.missing("average") }
        
        self.name = name
        self.average = average
    }
    
    func allAreas(completion: @escaping ([Area]) -> Void) {
        
        
        var areasURLComponents = College.urlComponents
        areasURLComponents?.path = "/areas"
        
        
        do {
            
            
            if let areasURL = areasURLComponents?.url {
                
                
                Major.session.dataTask(with: areasURL, completionHandler:  { (data,response, error)  in
                    
                    var areas = [Area]()
                    
                    if error != nil {
                        return
                    }
                    else if let data = data {
                        
                        let areasJson = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]]
                        
                        
                        
                        areasJson??.forEach{ area in
                            
                            try? areas.append(Area(json: area))
                            
                        }
                        
                    }
                    
                    completion(areas)
                }).resume()
                
            }
            
        }
        
    }

}

