//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 21/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    var video: Video? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        musicTitle.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
        musicTitle.text = video?.vName
        rank.text = String(video!.vRank)   //could also do  = ("\(video?.vRank)")
        //musicImage.image = UIImage(named: "imageNotAvailable") // not required anymore
        
        if video!.vImageData != nil {
            print("Get data from array ...")
            musicImage.image = UIImage(data: video!.vImageData! as Data)
        } else {
            getVideoImage(video!, imageView: musicImage)
            print("Get images in background thread")
        }
    }
    
    func getVideoImage(_ video: Video, imageView : UIImageView) {
        
        // Background thread
        #if swift(>=2.3)
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                let data = try? Data(contentsOf: URL(string: video.vImageUrl)!)
                var image : UIImage?
                if data != nil {
                    video.vImageData = data
                    image = UIImage(data: data!)
                }
            }
        #else
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                let data = try? Data(contentsOf: URL(string: video.vImageUrl)!)
                var image : UIImage?
                if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
                }
            }
        #endif
        
        let data = try? Data(contentsOf: URL(string: video.vImageUrl)!)
        var image : UIImage?
        if data != nil {
            video.vImageData = data
            image = UIImage(data: data!)
        }
        
        // move back to Main Queue
        DispatchQueue.main.async {
            imageView.image = image
        }
        
    }
}
