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
        musicTitle.text = video?.vName
        rank.text = String(video!.vRank)    //could also do  = ("\(video?.vRank)")
        musicImage.image = UIImage(named: "imageNotAvailable")
    }
    
}
