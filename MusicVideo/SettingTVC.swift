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
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange as NSNotification.Name, object: nil)

        tableView.alwaysBounceVertical = false
        
        // get touchID setting from UserDefaults
        touchID.isOn = UserDefaults.standard.bool(forKey: "SecSetting")
        
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
