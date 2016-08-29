//
//  SettingTVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 28/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewController {
    
    
    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedBackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!   // UISwitch gets initialized by XCode, doesn't need checking / initialization like Slider
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange as NSNotification.Name, object: nil)

        tableView.alwaysBounceVertical = false
        
        // get touchID setting from UserDefaults
        touchID.isOn = UserDefaults.standard.bool(forKey: "SecSetting")
        
        // Slider count form UserDefaults (also check and protect against first time nil value execution
        if UserDefaults.standard.object(forKey: "APICount") != nil {
            let theValue = UserDefaults.standard.object(forKey: "APICount") as! Int
            APICount.text = ("\(theValue)")
            sliderCount.value = Float(theValue)
        } else {
            sliderCount.value = 10.0
            APICount.text = String(Int(sliderCount.value))
        }
        
    }
    
    // Slider values from the Slider
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(Int(sliderCount.value), forKey: "APICount")
        APICount.text = String(Int(sliderCount.value))
    }
    
    // store touchID setting in UserDefaults
    @IBAction func touchIDSecurity(_ sender: UISwitch) {
        
        let defaults = UserDefaults.standard
        if touchID.isOn {
            defaults.set(touchID.isOn, forKey: "SecSetting")
        } else {
            defaults.set(false, forKey: "SecSetting")
        }
    }
    
    func preferredFontChange() {
        aboutDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        feedBackDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        APICount.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        
    }
    
    // Deinit - remove observers as object is de-allocated
    deinit {
        NotificationCenter.default.removeObserver(self, name: "preferredFontChange" as NSNotification.Name, object: nil)
    }

    
}
