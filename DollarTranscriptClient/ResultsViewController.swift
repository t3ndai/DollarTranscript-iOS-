//
//  ResultsViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 3/20/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ResultsViewController: UIViewController, MKMapViewDelegate, JobDataDelegate {
    
    // MARK: - Delegates
    
    let searchSession = URLSession(configuration: .default)
    
    var locationSet = Set<String>()
    
    var locations = [String]()
    
    var locationMap = [String: Int](){
        didSet{
            print(locationMap)
        }
    }
    
    let job = Job()
    var jobs = [Job]() {
        didSet {
            OperationQueue.main.addOperation {
                self.drawChart()
            }
            
        }
    }
    var geocoder = CLGeocoder()
    
    
    @IBOutlet weak var resultsMap: MKMapView!
    @IBOutlet weak var chartView: UIView!

    @IBOutlet weak var maxSalary: UILabel!
    @IBOutlet weak var minSalary: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       loadJobs()
        
        let locationDescriptor = NSSortDescriptor(key: "location", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - MapView Annotations
    
    func mapviewAnnotations(locationCoordinate : CLLocationCoordinate2D) {
        
        resultsMap.delegate = self 
        
        let coordinates = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        let circle = MKCircle(center: coordinates , radius: CLLocationDistance(50000))
        
        //resultsMap.add(circle)
        resultsMap.addAnnotation(circle)
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor(red: 46/255, green: 64/255, blue: 82/255, alpha: 0.5)  //79,100,111
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.clear
        let countLabel = UILabel()
        countLabel.text = "\(jobs.count)"
        

        
        
        return circleRenderer
    }
    
    
    func geocodeLocations(completion: ([CLLocationCoordinate2D]) -> Void) {
    
        var coordinates: [CLLocationCoordinate2D] = []
        locations.forEach{ location in
            
            geocoder.geocodeAddressString(location){ placemarks, error in
                
                placemarks?.forEach({ placemark in
                    
                    let latitude = placemark.location?.coordinate.latitude ?? 0.0
                    let longitude = placemark.location?.coordinate.longitude ?? 0.0
                    
                    let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    coordinates.append(locationCoordinate)
                    //print(locationCoordinate)
                    
                    
                })
                
            }
            completion(coordinates)
        }
        
    }
    
    //MARK: - Chart
    
    func drawChart() {
        
        let salaries = jobs.flatMap{ $0.pay}
        let width: CGFloat = chartView.frame.width
        let height: CGFloat = chartView.frame.height
        
        
        maxSalary.text = String(describing: salaries.max() ?? 150000)
        
        minSalary.text = String(describing: salaries.min() ?? 20000)
        
        let chart = CAShapeLayer()
        chart.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let path = UIBezierPath()

        let chartYPoint = salaries.flatMap { CGFloat($0)*(chart.bounds.height / 150000) }
        var spacing = 10 + chart.bounds.width / CGFloat(salaries.count - 1)
        
        //10 + chart.bounds.width / CGFloat(arrayValues.count)
        
        path.move(to: CGPoint(x:10, y: 0.5*height))
        //path.addLine(to: CGPoint(x: 100.0, y: 100.0))
        
        
        for yPoint in chartYPoint {
            path.addLine(to: CGPoint(x: spacing, y: yPoint))
            spacing += spacing
            
        }
        
        
        chart.path = path.cgPath
        //chart.strokeColor = UIColor.black.cgColor
        //chart.fillColor = UIColor.black.cgColor
        chart.lineWidth = 1.0

        
        self.chartView.layer.addSublayer(chart)
    }
    
    
    
    
    //MARK: - JobsDataDelegate Conform
    
    
    func passJobData(jobs: [Job]) {
        self.jobs = jobs
    }
    
    func loadJobs() {
        
        job.allJobs(completion: { [unowned self] jobs in
            
            jobs.forEach{ job in
                
                self.jobs.append(job)
                //print(self.locationMap)
                //self.locationMap[job.location] = (self.locationMap[job.location] ?? 0) + 1
                OperationQueue.main.addOperation {
                    self.mapviewAnnotations(locationCoordinate: CLLocationCoordinate2D(latitude: job.latitude, longitude: job.longitude))
                    
                }
                
                
            }
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationViewController = segue.destination as? SearchViewController {
            
            destinationViewController.jobsDelegate = self
        }
    }
    
    @IBAction func unwindToResultsView(sender: UIStoryboardSegue) {
        
        
        //print("unwind to results")
        
        /*if let sourceViewController = sender.source as? SearchViewController, let jobs = sourceViewController.jobs {
            
                self.jobs = jobs
   
        }*/
        
        
    }
    
    
 

}
