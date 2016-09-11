//
//  SettingTVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 28/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit
import MessageUI

class SettingTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedBackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!  // UISwitch gets initialized by XCode, doesn't need checking and manual initialization like Slider
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var numberOfVideosDisplay: UILabel!
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var dragTheSliderDisplay: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingTVC.preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        tableView.alwaysBounceVertical = false
        
        // get touchID setting from UserDefaults
        title = "Settings"
        touchID.isOn = UserDefaults.standard.bool(forKey: "SecSetting")
        
        // Slider count from UserDefaults (also check and protect against first time nil value execution
        if (UserDefaults.standard.object(forKey: "APICount") != nil) {
            let theValue = UserDefaults.standard.object(forKey: "APICount") as! Int
            APICount.text = "\(theValue)"
            sliderCount.value = Float(theValue)
        } else {
            sliderCount.value = 20.0
            APICount.text = ("\(Int(sliderCount.value))") // converted to string
        }
    }
    
    // Slider values from the Slider
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(Int(sliderCount.value), forKey: "APICount")
        APICount.text = ("\(Int(sliderCount.value))")
    }
    
    // store touchID setting in UserDefaults
    @IBAction func touchIdSec(_ sender: UISwitch) {
        
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
        numberOfVideosDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        dragTheSliderDisplay.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleFootnote)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if indexPath.section == 0 && indexPath.row == 1 {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
            let mailComposeViewController = configureMail()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController,  animated: true, completion: nil)
            } else {
                // No email account Setup on Phone
                mailAlert()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func configureMail() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["mubb20@gmail.com"])
        mailComposeVC.setSubject("Music Video App Feedback")
        mailComposeVC.setMessageBody("Hi Mubbasher,\n\n I would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
    }
    
    func mailAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No email account setup for Phone", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            //do something if required
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // protocol
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue: print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue: print("Mail saved")
        case MFMailComposeResult.sent.rawValue: print("Mail sent")
        case MFMailComposeResult.failed.rawValue: print("Mail failed")
        default: print("Unknown issue")
        }
        self.dismiss(animated: true, completion: nil)
    }
    // Deinit - remove observers as object gets de-allocated
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
}
