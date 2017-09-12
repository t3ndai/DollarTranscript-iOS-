//
//  SearchResultsViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 7/9/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import MapKit

class SearchResultsViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    
    
    @IBAction func done(_ sender: UIButton) {
        
        visualEffectView.isHidden = true
        searchView.isHidden = true
        
        let jsonQuery: [String: Any] = ["selector": [
            
            "$or" : [
                ["location": "\(locationQuery)"],
                ["college": "\(collegeQuery)"],
                ["pay.year": ["$lte": pay]]
            ]
            
            
            ]
        ]
        
        
        
        /*job.jobQueries(query: jsonQuery, completion: { jobTitles in
         print(jobTitles)
         })*/
        
        /*job.jobQueries(query: jsonQuery, completion: { [unowned self] jobs in
            
            self.jobsDelegate?.passJobData(jobs: jobs)
            
        })*/
        
    }
    
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var paySlider: UISlider!
    @IBOutlet weak var map: MKMapView!
    
    var pay = Int()
    var locationQuery = String()
    var collegeQuery = String()
    
    var job = Job()
    
    
    //MARK: - Slider Configuration
    
    func configureSlider() {
        
        paySlider.isContinuous = true
        paySlider.addTarget(self, action: #selector(SearchResultsViewController.sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    func sliderValueDidChange(_ slider: UISlider){

        self.pay = Int(slider.value)
        
    }
    
    //MARK: - Textview Delegates
    
    func textViewDelegates () {
        
        location.delegate = self
        college.delegate = self
        
        location.addTarget(self, action: #selector(SearchResultsViewController.textFieldDidChange(_:)), for: .editingChanged)
        college.addTarget(self, action: #selector(SearchResultsViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case location: self.locationQuery = textField.text!.trimmingCharacters(in: .whitespaces)
        case college: self.collegeQuery = textField.text!.trimmingCharacters(in: .whitespaces)
        default: break
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
        case location: self.locationQuery = textField.text!.trimmingCharacters(in: .whitespaces)
        case college: self.collegeQuery = textField.text!.trimmingCharacters(in: .whitespaces)
        default: break
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.becomeFirstResponder()
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //paySlider.transform = paySlider.transform.rotated(by: CGFloat(180.0/180*M_PI))
        
        textViewDelegates()
        
        configureSlider()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
