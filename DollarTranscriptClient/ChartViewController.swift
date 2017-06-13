//
//  ChartViewController.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 5/25/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var maxSalary: UILabel!
    @IBOutlet weak var minSalary: UILabel!
    

    //MARK: - Properties 
    var job = Job()
    var jobs = [Job](){
        didSet{
            OperationQueue.main.addOperation {
                self.drawChart()
            }
        }
    }
    
    var salaries = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadJobs()
        loadSalaries()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        jobs = []
        salaries = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Chart
    
    func drawChart() {
        

        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height
        
        maxSalary.text = String(describing: salaries.max() ?? 150000)
        minSalary.text = String(describing: salaries.min() ?? 30000)
        
        let chart = CAShapeLayer()
        chart.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let path = UIBezierPath()
        
        let chartYPoint = salaries.flatMap { CGFloat($0)*(chart.bounds.height / 100000) }
        let spacing = chart.bounds.width / CGFloat(salaries.count - 1 )
        
        path.move(to: CGPoint(x: spacing, y: chartYPoint.first ?? 0))
        var x: CGFloat = spacing
        
        for yPoint in chartYPoint {
            x += spacing
            path.addLine(to: CGPoint(x: x, y: yPoint))
            
        }
        
        chart.path = path.cgPath
        chart.lineWidth = 1.0
        chart.fillColor = UIColor.clear.cgColor
        chart.strokeColor = UIColor.black.cgColor
        
        self.view.layer.addSublayer(chart)
        
        
    }
    
    func loadJobs() {

        
        job.allJobs { (jobs) in
            jobs.forEach{ job in
                self.jobs.append(job)
            }
        }
    }
    
    
    func loadSalaries(){
        
        job.allSalaries { (salaries) in
            salaries.forEach{ salary in
                self.salaries.append(salary)
            }
        }
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
