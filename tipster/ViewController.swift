//
//  ViewController.swift
//  tipster
//
//  Created by Pranav Achanta on 1/3/16.
//  Copyright © 2016 pranav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    var userSettings: UserSettings!
    var changedFirstTime = false
    var firstScreenLoad = false
    var startTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Tipster"
        
        print("viewDidLoad")
        
        // Get the Start Time from NSUserDefaults
        let defualts = NSUserDefaults.standardUserDefaults()
        let timeStamp = defualts.objectForKey("timeStamp")
        if(timeStamp != nil){
            // Check the elapsed time and see if it is less than 10 mins
            let elapsedTime = NSDate().timeIntervalSinceDate(timeStamp as! NSDate)
            if(elapsedTime < 20){
                changedFirstTime = true
                firstScreenLoad = true
                // Get the Previously Stored Value
                let billAmount = defualts.doubleForKey("billAmount")

                // Update the Bill Amount ans set the Tip
                billField.text = String(format: "%.2f", billAmount)
                reload()
                animate()
            }
        }

        // Update the TimeStamp in the defaults now
        defualts.setObject(NSDate(), forKey: "timeStamp")
        defualts.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        if(!changedFirstTime){
            changedFirstTime = true
            animate()
            // Get the Fields in bound now
            self.tipPercentageSegment.center.x += self.view.bounds.width
            self.bottomView.center.x += self.view.bounds.width
        }
        
        // Store the Value
        setTip()
    }
    
    func animate(){
        // Animation Code goes here!!
        UIView.animateWithDuration(0.7, animations: {
            var topFrame = self.topView.frame
            topFrame.origin.y -= topFrame.size.height
            
            self.topView.frame = topFrame
            },completion: { finished in
                print("Animation Completed")
        })
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func setTip(){
        let tipPercentages = [userSettings.per1,userSettings.per2,userSettings.per3]
        let tipPercentage = tipPercentages[tipPercentageSegment.selectedSegmentIndex]
        
        if(billField.text != ""){
            let billAmount = Double(billField.text!)!
            let tip = billAmount * tipPercentage
            let total = billAmount + tip
        
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            
            // Store the bill amount in a variable
            let defualts = NSUserDefaults.standardUserDefaults()
            defualts.setDouble(billAmount, forKey: "billAmount")
            defualts.synchronize()
        }else{
            let tip = 0
            let total = 0
            
            tipLabel.text = "$\(tip)"
            totalLabel.text = "$\(total)"
            
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
        }
    }
    
    func reload() {
        userSettings = UserSettings.readFromDisk()
        tipPercentageSegment.setTitle(String(Int(userSettings.per1 * 100))+"%", forSegmentAtIndex: 0)
        tipPercentageSegment.setTitle(String(Int(userSettings.per2 * 100))+"%", forSegmentAtIndex: 1)
        tipPercentageSegment.setTitle(String(Int(userSettings.per3 * 100))+"%", forSegmentAtIndex: 2)
        setTip()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View Will Appear")
        
        // Take all fields except the text field out bounds
        if(!firstScreenLoad){
            firstScreenLoad = true
            tipPercentageSegment.center.x -= view.bounds.width
            bottomView.center.x -= view.bounds.width
        }
        
        // Make the bill amount field the first responder
        billField.becomeFirstResponder()
        // Reload the UserDefault Values
        reload()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("View Will Disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        startTime = NSDate()
        print("View Did Disappear")
    }
}

