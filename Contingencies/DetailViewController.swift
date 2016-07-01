//
//  DetailViewController.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/23/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func updateAssumptions()
    func dismiss()
}
    
class DetailViewController: UIViewController, TypeViewControllerDelegate, MortalityViewControllerDelegate, UITextFieldDelegate {
    var delegate: DetailViewControllerDelegate! = nil
    var assumptions = Assumptions()
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var tableLabel: UILabel!
    @IBOutlet var termLabel: UILabel!
    @IBOutlet var interestTextField: UITextField!
    @IBOutlet var termTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Assumptions"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        //Tag text fields to differentiate in TextFieldDelegate methods
        interestTextField.tag = 1
        termTextField.tag = 2
        
        interestTextField.text = "\(assumptions.interest)"
        updateTermInput(assumptions.type)
        updateType(assumptions.type)
    }

    @IBAction func done() {
        switch assumptions.type.termType {
        case "Term":
            if assumptions.term == nil {
                alertForMissingField("Term")
                return
            }
        case "Deferral":
            if assumptions.deferralPeriod == nil {
                alertForMissingField("Deferral")
                return
            }
        default:
            break
        }
        
        self.delegate!.updateAssumptions()
        self.delegate!.dismiss()
    }
    
    func alertForMissingField(description: String) {
        let alert = UIAlertController(title: "Please choose a \(description)", message: nil, preferredStyle: .Alert)
        let dismissButton = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissButton)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editType() {
        let vc = TypeViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editMortalityTable() {
        let vc = MortalityViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 1 {
            handleTypeTextUpdate(textField)
        } else {
            handleTableTextUpdate(textField)
        }
    }
    
    func handleTypeTextUpdate(textField: UITextField) {
        if let interest = Double(textField.text!) {
            if interest < 0 || interest > 25 {
                textField.text = ""
            } else {
                assumptions.interest = interest
            }
        } else {
            textField.text = ""
        }
    }
    
    func handleTableTextUpdate(textField: UITextField) {
        if let term = Int(textField.text!) {
            if term < 0 || term > 120 {
                textField.text = ""
                if assumptions.type.termType == "Term" {
                    assumptions.term = nil
                } else {
                    assumptions.deferralPeriod = nil
                }
            } else {
                if assumptions.type.termType == "Term" {
                    assumptions.term = term
                } else {
                    assumptions.deferralPeriod = term
                }
            }
        } else {
            textField.text = ""
        }
    }
    
    //MARK: TypeViewControllerDelegate
    
    func updateType(type: Contingency) {
        assumptions.type = type
        typeLabel.text = type.description
        updateTermInput(type)
    }
    
    func updateTermInput(type: Contingency) {
        switch type.termType {
        case "Term":
            termLabel.text = "Term"
            if let term = assumptions.term {
                termTextField.text = "\(term)"
            } else {
                termTextField.text = ""
            }
            termTextField.userInteractionEnabled = true
        case "Deferral":
            termLabel.text = "Deferral Period"
            if let deferralPeriod = assumptions.deferralPeriod {
                termTextField.text = "\(deferralPeriod)"
            } else {
                termTextField.text = ""
            }
            termTextField.userInteractionEnabled = true
        default:
            termTextField.text = "n/a"
            termTextField.userInteractionEnabled = false
        }
    }
    
    //MARK: MortalityViewControllerDelegate
    
    func updateMortalityTable(table: MortalityTable) {
            //assumptions.mortalityTable = table
            tableLabel.text = table.description
    }
}
