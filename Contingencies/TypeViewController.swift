//
//  TypeViewController.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/26/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import UIKit

protocol TypeViewControllerDelegate {
    func updateType(type: Contingency)
}

class TypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    let typeArray: [Contingency] = [.LifeAnnuityImmediate,
                                    .LifeAnnuityDue,
                                    .TermAnnuityImmediate,
                                    .TermAnnuityDue,
                                    .DeferredAnnuityImmediate,
                                    .DeferredAnnuityDue]
    
    var delegate: TypeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Type"
    }
    
    //Mark: TableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel?.text = typeArray[indexPath.row].description
        
        return cell
    }
    
    //Mark: TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            delegate.updateType(typeArray[indexPath.row])
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
