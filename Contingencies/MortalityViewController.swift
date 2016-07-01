//
//  MortalityViewController.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/27/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import UIKit

protocol MortalityViewControllerDelegate {
    func updateMortalityTable(table: MortalityTable)
}

class MortalityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: MortalityViewControllerDelegate?
    let tableArray: [MortalityTable] = [.PPA_2016_blended]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Mortality Table"
    }
    
    //Mark: TableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel?.text = tableArray[indexPath.row].description
        
        return cell
    }
    
    //Mark: TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            delegate.updateMortalityTable(tableArray[indexPath.row])
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
