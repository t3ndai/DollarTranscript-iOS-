//
//  SearchViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 4/12/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import QuartzCore


protocol JobDataDelegate {
    
    func passJobData (jobs: [Job])
}

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var viewLayer: UIView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var college: UITextField!
    
    var job = Job()
    var jobs: [Job]?
    var payValue = Int()
    
    var jobsDelegate: JobDataDelegate?
    
    
    @IBOutlet weak var pay: UISlider!

    @IBAction func done(_ sender: UIButton) {
        
      
        let jsonQuery: [String: Any] = ["selector": [
            
            "$or" : [
                ["location": "\(job.location)"],
                ["college": "\(job.college)"],
                ["pay.year": ["$lte": payValue]]
            ]
            
            
            ]
        ]
        
        /*job.jobQueries(query: jsonQuery, completion: { jobTitles in
            print(jobTitles)
        })*/
        
        job.jobQueries(query: jsonQuery, completion: { [unowned self] jobs in
            
            self.jobsDelegate?.passJobData(jobs: jobs)

        })
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewDelegates()
        configureSlider()
        self.viewLayer.addShadow()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Textview Delegates
    
    func textViewDelegates () {
        
        location.delegate = self
        college.delegate = self
        
        location.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        college.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case location: self.job.location = textField.text!.trimmingCharacters(in: .whitespaces)
        case college: self.job.college = textField.text!.trimmingCharacters(in: .whitespaces)
        default: break
        }
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
        case location: self.job.location = textField.text!.trimmingCharacters(in: .whitespaces)
        case college: self.job.college = textField.text!.trimmingCharacters(in: .whitespaces)
        default: break
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.becomeFirstResponder()
    }
    
    //MARK: - Slider Configuration
    
    func configureSlider() {
        
        pay.isContinuous = true
        pay.addTarget(self, action: #selector(SearchViewController.sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    func sliderValueDidChange(_ slider: UISlider){
        
        self.payValue = Int(slider.value)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        jobs = [Job]()
    }
    
    
    

}

extension UIView {
    
    
    //MARK: - Corners
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            
            return layer.cornerRadius
        }
    }
    
    
    @IBInspectable var shadowOffest: CGSize {
        set{
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set{
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set{
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    //OFF will show shadow | ON won't | DEFAULT is OFF
    @IBInspectable var maskToBounds: Bool {
        set{
            layer.masksToBounds = newValue
        }
        get{
            return layer.masksToBounds
        }
    }
    
    
    @IBInspectable var shadowPath: CGPath {
        set {
            layer.shadowPath = newValue
        }
        get {
            return UIBezierPath(rect: bounds).cgPath
        }
    }
    

    
    func addShadow() {
        
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0.5, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
}
