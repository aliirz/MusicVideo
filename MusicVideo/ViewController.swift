//
//  ViewController.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 06/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]){
        print(reachabilityStatus)
        for (index,item) in videos.enumerated() {
            print("\(index). \(item.vName)")
        }
        
        
    }
    
}

