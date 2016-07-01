//
//  ViewController.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/11/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import UIKit

class CustomTableViewCell : UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func loadItem(title: String) {
        titleLabel.text = title
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var interestLabel: UILabel!
    @IBOutlet var mortalityLabel: UILabel!
    @IBOutlet var termTitleLabel: UILabel!
    @IBOutlet var termLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    var assumptions: Assumptions!
    var contingencyArray = [Double]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        assumptions = Assumptions()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        assumptions = Assumptions()
        
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAssumptions()
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
    }
    
    @IBAction func change() {
        let vc = DetailViewController()
        vc.delegate = self
        vc.assumptions = assumptions

        let navController = UINavigationController(rootViewController: vc)
        
        presentViewController(navController, animated: true, completion: nil)
    }
    
    //MARK: Table View Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contingencyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell")! as! CustomTableViewCell
        
        cell.titleLabel.text? = "\(indexPath.row)"
        
        ///round to 6 decimals
        let value = round(1000000 * contingencyArray[indexPath.row])/1000000
        
        cell.valueLabel.text? = "\(String(NSString(format: "%.6f", value)))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    //MARK: DetailViewController Delegate
    
    func updateAssumptions() {
        let interest = assumptions.interest / 100
        let mortalityTable = assumptions.mortalityTable
        var termOrDeferral: Int?
        switch assumptions.type.termType {
        case "Term":
            termOrDeferral = assumptions.term
        case "Deferral":
            termOrDeferral = assumptions.deferralPeriod
        default:
            break
        }
        let annuityTable = AnnuityTable(interest: interest, mortalityTable: mortalityTable, termOrDeferral: termOrDeferral)
        
        contingencyArray = assumptions.type.valueFromTable(annuityTable)
        
        titleLabel.text = assumptions.type.description
        interestLabel.text = "\(assumptions.interest)%"
        
        if assumptions.type.termType == "Term" {
            termTitleLabel.text = "Term"
            termLabel.text = "\(assumptions.term!)"
        } else if assumptions.type.termType == "Deferral" {
            termTitleLabel.text = "Deferral Period"
            termLabel.text = "\(assumptions.deferralPeriod!)"
        } else {
            termTitleLabel.text = "Term"
            termLabel.text = "n/a"
        }
        
        tableView.reloadData()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

