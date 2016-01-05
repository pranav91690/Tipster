//
//  UserSettings.swift
//  tipster
//
//  Created by Pranav Achanta on 1/3/16.
//  Copyright © 2016 pranav. All rights reserved.
//

import UIKit

class UserSettings: NSObject {
    var per1: Double = 0.1
    var per2: Double = 0.15
    var per3: Double = 0.2
    
    init(per1: Double, per2: Double, per3: Double) {
        if(per1 != 0){
            self.per1 = per1;
        }
        if(per2 != 0){
            self.per2 = per2;
        }
        if(per3 != 0){
            self.per3 = per3;
        }
    }
    
    func writeToDisk() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(per1, forKey: "percentage1")
        defaults.setDouble(per2, forKey: "percentage2")
        defaults.setDouble(per3, forKey: "percentage3")
        defaults.synchronize()
    }
    
    class func readFromDisk() -> UserSettings {
        let defaults = NSUserDefaults.standardUserDefaults()
        let per1 = defaults.doubleForKey("percentage1")
        let per2 = defaults.doubleForKey("percentage2")
        let per3 = defaults.doubleForKey("percentage3")
        
        return UserSettings(per1: per1, per2: per2, per3: per3)
    }

}
