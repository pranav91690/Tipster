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
    @IBOutlet weak var splitAmountLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var CountStepper: UIStepper!
    @IBOutlet weak var bottomRightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    
    var userSettings: UserSettings!
    var changedFirstTime = false
    var firstScreenLoad = false
    var startTime = NSDate()
    var cleanSlate = false
    var tipGlobal = 0.0
    var inStage1 = false
    var inOriginalStage = false

    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        calSplit(Int(sender.value))
    }
    
    func calSplit(people : Int){
        countLabel.text = people.description
        splitAmountLabel.text = String(format: "$%.2f", tipGlobal/Double(people))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Tipster"
        
        CountStepper.wraps = true
        CountStepper.autorepeat = true
        CountStepper.maximumValue = 4
        CountStepper.minimumValue = 1
        
        splitAmountLabel.text = "S0.00"
        
        print("viewDidLoad")
        
        // Get the Start Time from NSUserDefaults
        let defualts = NSUserDefaults.standardUserDefaults()
        let timeStamp = defualts.objectForKey("timeStamp")
        if(timeStamp != nil){
            // Check the elapsed time and see if it is less than 10 mins
            let elapsedTime = NSDate().timeIntervalSinceDate(timeStamp as! NSDate)
            if(elapsedTime < 10){
                // If yes, set the bill amount with the saved value
                changedFirstTime = true
                firstScreenLoad = true
                // Get the Previously Stored Value
                let billAmount = defualts.doubleForKey("billAmount")

                // Update the Bill Amount ans set the Tip
                billField.text = String(format: "%.2f", billAmount)
                
                animateOriginalStage()
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
        // Store the Value
        setTip()
    }
    
    func animateStage1(){
        inStage1 = true
        if(inOriginalStage){
            inOriginalStage = false
            // Animation Code goes here!!
            UIView.animateWithDuration(0.7, animations: {
                var topFrame = self.topView.frame
                topFrame.origin.y -= topFrame.size.height
                
                self.topView.frame = topFrame
                },completion: { finished in
                    print("Animation Completed")
            })
            
            // Make the Out of Bound Fields in bound now
            self.tipPercentageSegment.center.x += self.view.bounds.width
            self.bottomView.center.x += self.view.bounds.width
            self.bottomRightView.center.x += self.view.bounds.width
        }
    }
    
    func animateOriginalStage(){
        inOriginalStage = true
        if(inStage1){
            inStage1 = false
            UIView.animateWithDuration(0.7, animations: {
                var topFrame = self.topView.frame
                topFrame.origin.y += topFrame.size.height
                
                self.topView.frame = topFrame
                },completion: { finished in
                    print("Animation Completed")
            })
        }
        
        // make the fields out of bound
        tipPercentageSegment.center.x -= view.bounds.width
        bottomView.center.x -= view.bounds.width
        bottomRightView.center.x -= view.bounds.width
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func setTip(){
        let tipPercentages = [userSettings.per1,userSettings.per2,userSettings.per3]
        let tipPercentage = tipPercentages[tipPercentageSegment.selectedSegmentIndex]
        
        if(billField.text != ""){
            // Get to Texting Stage
            animateStage1()
            
            let billAmount = Double(billField.text!)!
            let tip = billAmount * tipPercentage
            let total = billAmount + tip
        
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            
            tipGlobal = tip
            
            calSplit(Int(countLabel.text!)!)
            
            // Store the bill amount in a variable
            let defualts = NSUserDefaults.standardUserDefaults()
            defualts.setDouble(billAmount, forKey: "billAmount")
            defualts.synchronize()
        }else{
            // Get Back to Original Stage
            animateOriginalStage()
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
        
        // Make the bill amount field the first responder
        billField.becomeFirstResponder()
        // Reload the UserDefault Values
        reload()
    }
    
    func hideFields(){
        tipPercentageSegment.center.x -= view.bounds.width
        bottomView.center.x -= view.bounds.width
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

