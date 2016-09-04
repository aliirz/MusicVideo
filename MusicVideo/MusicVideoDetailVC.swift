//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 27/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
// You are a millionaire.... ego meter

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {
    
    var securitySwitch: Bool = false
    var videos:Videos!
    
    // Outlets
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = videos.vArtist
        vName.text = videos.vName
        vPrice.text = videos.vPrice
        vRights.text = videos.vRights
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil {
            videoImage.image = UIImage(data: videos.vImageData! as Data)
            
        } else {
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
    }
    
    @IBAction func socialMedia(_ sender: UIBarButtonItem) {
        securitySwitch = UserDefaults.standard.bool(forKey: "SecSetting")
        switch securitySwitch {
        case true:
            touchIDCheck()
        default:
            shareMedia()
        }
    }
    
    func touchIDCheck() {
        // create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        
        // create Local Authetication context
        let context = LAContext()
        var touchIDError : NSError?
        let reasonString = "Touch-ID authentication is needed to share information on social media"
        
        // check if we can access Local Device Authentication
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &touchIDError) {
            // check what the authentication response was
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    // user authenticated using Local Device Authentication successfully
                    DispatchQueue.main.async { [unowned self] in
                    self.shareMedia()
                    }
                } else {
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)! {
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                    case .PassCodeNotSet:
                        alert.message = "Passcode is not set on the device"
                    case .SystemCancel:
                        alert.message = "Too many failed attempts"
                    case .UserCancel:
                        alert.message = "You cancelled  the request"
                    case .UserFallBack:
                        alert.message = "Password not accepted, must use Touch-ID"
                    default:
                        alert.message = "Unable to authenticate!"
                    }
                    
                    // show the alert
                    DispatchQueue.main.async { [unowned self] in
                    self.presentedViewController(alert, animated: true, completion: nil)
                    }
                }
                } else {
                // unable to access local device authentication
                // set the error title
                alert.title = "Error"
                
                // set the error alert messgage with more information
                switch LAerror(rawValue: touchIDError!.code)! {
                case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                case .TouchIDNotAvailable:
                alert.message = "TouchID is not available on the device"
                case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
                case .InvalidContext:
                alert.message = "The context is invalid"
                default:
                alert.message = "Local Authentication not available"
                }
                
                // show the alert
                DispatchQueue.main.async { [unowned self] in
                self.presentedViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func shareMedia() {
        let activity1 = "Have you seen this Music Video yet?"
        let activity2 = "\(videos.vName) by \(videos.vArtist)."
        let activity3 = "Watch it and let me know what you think?"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "(shared with the Music Video app- by Mubb)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        // activityViewController.excludedActivityTypes = [UIActivityTypeMail]
        
        // activityViewController.excludedActivityTypes = [
            //            UIActivityTypePostToTwitter,
            //            UIActivityTypePostToFacebook,
            //            UIActivityTypePostToWeibo,
            //            UIActivityTypeMessage,
            //            UIActivityTypeMail,
            //            UIActivityTypePrint,
            //            UIActivityTypeCopyToPasteboard,
            //            UIActivityTypeAssignToContact,
            //            UIActivityTypeSaveToCameraRoll,
            //            UIActivityTypeAddToReadingList,
            //            UIActivityTypePostToFlickr,
            //            UIActivityTypePostToVimeo,
            //            UIActivityTypePostToTencentWeibo
            //        ]
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func playVideo(_ sender: UIBarButtonItem) {
        let url = NSURL(string: videos.vVideoUrl)!
        let player = AVPlayer(url: url as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }

}
}
