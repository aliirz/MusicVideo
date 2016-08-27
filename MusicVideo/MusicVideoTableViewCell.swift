//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 21/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    var video : Videos? {
        didSet{
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
        rank.text = String(video!.vRank)    //could also do  = ("\(video?.vRank)")
        //musicImage.image = UIImage(named: "imageNotAvailable")
        
        if video?.vImageData != nil {
            print("Get data from array...")
            musicImage.image = UIImage(data: video!.vImageData! as Data)
        } else {
            getVideoImage(video: video!, imageView: musicImage)
            print("get images in background thread")
        }
    
    }
    
    func getVideoImage(video: Videos, imageView: UIImageView){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
            let data = NSData(contentsOf: NSURL(string: video.vImageUrl)! as URL)
            var image : UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data! as Data)
            }
            
        }
        
    }
        
    
    
    
    
}
