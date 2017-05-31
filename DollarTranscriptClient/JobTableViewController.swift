//
//  JobTableViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 5/23/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import CoreLocation

enum PaySegments: Int {
    case hourly
    case monthly
    case yearly
}

class JobTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - IB Actions
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addJob(_ sender: UIBarButtonItem) {
        
        self.job.addJob(job: job)
        dismiss(animated: true, completion: nil)
        
    }
    
    
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
    
    @IBAction func sponsorship(_ sender: UISwitch) {
        
        self.job.sponsorship = sponsorship.isOn
      
    }
    
    
    
    //MARK: - IB Outlets
    
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var pay: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var payType: UISegmentedControl!
    @IBOutlet weak var sponsorship: UISwitch!
    
    //MARK: - Properties
    
    var job = Job()
    
    var payValue: Int = 0 {
        didSet {
            payType.addTarget(self, action: #selector(JobTableViewController.paySegment(_:)), for: .valueChanged)
            
        }
    }
    
    
    var locationName: String = "" {
        didSet {
            if locationName != job.location {
                locationName = job.location
            }
            getLocation()
        }
    }
    
    
    var geocoder = CLGeocoder()
    
    
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
        case major:
            self.job.major = textField.text!.trimmingCharacters(in: .whitespaces)
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
        case major:
            self.job.major = textField.text!.trimmingCharacters(in: .whitespaces)
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
        major.delegate = self
        
        
        jobTitle.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        location.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        pay.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        company.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        college.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        major.addTarget(self, action: #selector(JobTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    //MARK: - Location
    
    func getLocation () {
        
        geocoder.geocodeAddressString(locationName, completionHandler: { placemarks, error in
            
            placemarks?.forEach{ placemark in
                
                let latitude = placemark.location?.coordinate.latitude ?? 0.0
                let longitude = placemark.location?.coordinate.longitude ?? 0.0

                
                self.job.latitude = latitude
                self.job.longitude = longitude
            }
        })
    }


    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        textViewDelegates()
        
        payType.addTarget(self, action: #selector(JobTableViewController.paySegment(_:)), for: .valueChanged)
        sponsorship.addTarget(self, action: #selector(JobTableViewController.sponsorship(_:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
