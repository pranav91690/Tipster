//
//  SettingsViewController.swift
//  tipster
//
//  Created by Pranav Achanta on 1/3/16.
//  Copyright © 2016 pranav. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var perc1Field: UITextField!
    @IBOutlet weak var perc2Field: UITextField!
    @IBOutlet weak var perc3Field: UITextField!
    
    var userSettings: UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSettings = UserSettings.readFromDisk()
        perc1Field.text = String((Int(userSettings.per1 * 100)))
        perc2Field.text = String((Int(userSettings.per2 * 100)))
        perc3Field.text = String((Int(userSettings.per3 * 100)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSet(sender: AnyObject) {
        userSettings.per1 = Double(perc1Field.text!)!/100
        userSettings.per2 = Double(perc2Field.text!)!/100
        userSettings.per3 = Double(perc3Field.text!)!/100
        userSettings.writeToDisk()
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
