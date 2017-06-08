//
//  Job.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 3/2/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import Foundation

enum Serialization: Error {
    
    case missing(String)
    case invalid(String, Any)
}

public struct Job {
    
    public var id: Int = 0
    public var title: String = ""
    public var location: String = ""
    public var pay: Int = 0
    public var company: String  = ""
    public var college: String = ""
    public var major: String = ""
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    public var sponsorship: Bool = false
    
    
}

extension Job {
    
    static let urlComponents = URLComponents(string: "http://0.0.0.0:8080")
    static let session = URLSession(configuration: .default)
    
    init(json: [String: Any]) throws {
        
        guard let id = json["id"] as? Int else { throw Serialization.missing("id") }
        guard let title = json["title"] as? String else { throw Serialization.missing("title") }
        guard let location = json["location"] as? String else { throw Serialization.missing("location") }
        guard let pay = json["pay"] as? Int else { throw Serialization.missing("pay") }
        guard let company = json["company"] as? String else { throw Serialization.missing("company") }
        guard let college = json["college"] as? String else { throw Serialization.missing("college") }
        guard let major = json["major"] as? String else { throw Serialization.missing("major") }
        guard let sponsorship = json["sponsorship"] as? Bool else { throw Serialization.missing("sponsorship") }
        guard let latitude = json["latitude"] as? Double else { throw Serialization.missing("latitude") }
        guard let longitude = json["longitude"] as? Double else { throw Serialization.missing("longitude") }
        
        self.id = id
        self.title = title
        self.location = location
        self.pay = pay
        self.company = company
        self.college = college
        self.major = major
        self.sponsorship = sponsorship
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
    func makeJson()  -> [String: Any]{
        
        let jsonObject: [String: Any] = [
            
            "title": self.title,
            "location": self.location,
            "pay": self.pay,
            "company": self.company,
            "college": self.college,
            "major": self.major,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "sponsorship": self.sponsorship
        ]
        
        return jsonObject
        
    }
    
    func addJob(job: Job) {
        
        var jobURLComponents = Job.urlComponents
        jobURLComponents?.path = "/jobs"
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: job.makeJson(), options: [.prettyPrinted])
            
            if let jobUrl = jobURLComponents?.url {
                var request = URLRequest(url: jobUrl)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let jobTask = Job.session.uploadTask(with: request, from: jsonData) { data, response, error in
                    
                    if error != nil {
                        print(error)
                    }
                    let response = String(data: data ?? Data(), encoding: String.Encoding.utf8)
                    print(response)
                }
                jobTask.resume()
            }
            
            
        }catch {
            print("Json serialization failed: \(error)")
        }
        
        
    }
    
    func allJobs(completion: @escaping ([Job]) -> Void) {
        
        
        var jobsURLComponents = Job.urlComponents
        jobsURLComponents?.path = "/jobs"
       
        
        do {
            
            
            if let jobsURL = jobsURLComponents?.url {
                
                
                Job.session.dataTask(with: jobsURL, completionHandler:  { (data,response, error)  in
                    
                    var jobs = [Job]()
                    
                    if error != nil {
                        return
                    }
                    else if let data = data {
                        
                        let jobsJson = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]]
                        
                        
                        
                        jobsJson??.forEach{ job in
                        
                            try? jobs.append(Job(json: job))

                        }
                        
                    }
                    
                    completion(jobs)
                }).resume()
                
            }
            
        }
        
    }
    
    func jobQueries(query: [String: Any], completion: @escaping ([Job]) -> Void) {
        
        var jobTitles = [String]()
        var jobURLComponents = Job.urlComponents
        jobURLComponents?.path = "/jobs/find"
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: query, options: .prettyPrinted)
            
            if let jobSearchUrl = jobURLComponents?.url {
                var request = URLRequest(url: jobSearchUrl)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                Job.session.uploadTask(with: request, from: jsonData, completionHandler: { (data, response, error) in
                    
                    var jobs: [Job] = []
                    
                    
                    if error != nil {
                        return
                    }
                    else if let data = data {
                        
                        let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]]
                        
                        
                        json??.forEach{ job in
                            jobTitles.append(job["title"] as! String)
                            try? jobs.append(Job(json: job))
                            
                        }
                        
                    }
                    completion(jobs)
                    
                }).resume()
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
}

