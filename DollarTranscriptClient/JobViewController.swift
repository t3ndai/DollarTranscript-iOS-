//
//  JobTableViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 3/1/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import CoreLocation


class JobViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var job = Job()
   
    var locationName: String = "" {
        didSet {
            if locationName != job.location {
                locationName = job.location
            }
            getLocation()
        }
    }
    
    var activeField : UITextField?
    
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var addJob: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var pay: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var payType: UISegmentedControl!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var sponsorship: UISwitch!
    
    var payValue: Int = 0 {
        didSet {
            payType.addTarget(self, action: #selector(JobTableViewController.paySegment(_:)), for: .valueChanged)

        }
    }
    
    let uploadSession = URLSession(configuration: .default)
    
    
    @IBAction func paySegment(_ sender: UISegmentedControl) {
        
       
        if let selectedpay = PaySegments(rawValue: payType.selectedSegmentIndex) {
        
            switch selectedpay {
                case .hourly:
                    self.job.pay = payValue * 2000
                case .monthly:
                    self.job.pay = payValue * 12
                case .yearly:
                    self.job.pay = payValue

            }
            
        }
    }
    

    @IBAction func addJob(_ sender: Any) {
        
        //self.job._id = UUID().uuidString
        self.job.sponsorship = sponsorship.isOn
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: job.makeJson(), options: [.prettyPrinted])
            
            
            if let url = URL(string: "http://0.0.0.0:8080/jobs"){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let uploadTask = uploadSession.uploadTask(with: request, from: jsonData) { data, response, error in
                    if error != nil {
                        print(error)
                    }
                    
                    let response = String(data: data ?? Data(), encoding: String.Encoding.utf8)
                    print(response)
                }
                uploadTask.resume()
            }

        }catch {
            print("Json serialization failed: \(error)")
        }
        
        
     dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Location
    
    func getLocation () {
        
        geocoder.geocodeAddressString(locationName, completionHandler: { placemarks, error in
            
            placemarks?.forEach{ placemark in
                
                let latitude = placemark.location?.coordinate.latitude ?? 0.0
                let longitude = placemark.location?.coordinate.longitude ?? 0.0
                
                print(latitude)
                print(longitude)
                
                self.job.latitude = latitude
                self.job.longitude = longitude
            }
        })
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.becomeFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            return
        }
        
        
        switch textField {
        case jobTitle:
            self.job.title = textField.text!.trimmingCharacters(in: .whitespaces)
        case location:
            self.job.location = textField.text!.trimmingCharacters(in: .whitespaces)
            self.locationName = self.job.location
        case pay:
            self.payValue = Int(textField.text!) ?? 0
        case company:
            self.job.company = textField.text!.trimmingCharacters(in: .whitespaces)
        case college:
            self.job.college = textField.text!.trimmingCharacters(in: .whitespaces)
        default:
            break
        }
        
        textField.resignFirstResponder()
        
       
    }
    
    func textFieldDidChange(_ textField: UITextField){
        
        switch textField {
        case jobTitle:
            self.job.title = textField.text!.trimmingCharacters(in: .whitespaces)
        case location:
            self.job.location = textField.text!.trimmingCharacters(in: .whitespaces)
            self.locationName = self.job.location
        case pay:
            self.payValue = Int(textField.text!) ?? 0
        case company:
            self.job.company = textField.text!.trimmingCharacters(in: .whitespaces)
        case college:
            self.job.college = textField.text!.trimmingCharacters(in: .whitespaces)
        default:
            break
        }
    }
    
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDelegates() {
        
        jobTitle.delegate = self
        location.delegate = self
        pay.delegate = self
        company.delegate = self
        college.delegate = self
        
        
        jobTitle.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        location.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        pay.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        company.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        college.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addShadow()
        self.view.layer.cornerRadius = 4
        
        textViewDelegates()
        
        
        let notification = NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        payType.addTarget(self, action: #selector(JobTableViewController.paySegment(_:)), for: .valueChanged)
        
        
    }
    
    //MARK:: - Keyboard Management
    
    func keyboardWillShow(notification: Notification) {
        
        
        
        
        let info: [AnyHashable: Any]? = notification.userInfo
        let kbSize: CGSize? = (info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets? = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        scroll.contentInset = contentInsets!
        scroll.scrollIndicatorInsets = contentInsets!
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        
        /*var bkgndRect = activeField?.superview?.frame
        bkgndRect?.size.height += kbSize!.height
        activeField?.superview?.frame(forAlignmentRect: bkgndRect!)
        scroll.setContentOffset(CGPoint(x: CGFloat(0.0),y: CGFloat((activeField?.frame.origin.y)!-kbSize!.height)), animated: true)
        */

        
        /*if !aRect.contains((activeField?.frame.origin)!) {
            self.scroll.scrollRectToVisible(activeField!.frame, animated: true)
        }
        */
        
        
    }
    
    func keyboardWillBeHidden(notification: Notification) {
        
            
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        scroll.contentInset = contentInsets
        scroll.scrollIndicatorInsets = contentInsets
        
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
