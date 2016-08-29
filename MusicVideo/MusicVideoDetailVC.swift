//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 27/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MusicVideoDetailVC: UIViewController {
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
        shareMedia()
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
