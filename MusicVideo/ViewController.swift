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
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding an observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "reachStatusChanged" as NSNotification.Name, object: nil)
        
        reachabilityStatusChanged()
        
        // call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]){
        print(reachabilityStatus)
        self.videos = videos
        for (index,item) in videos.enumerated() {
            print("\(index).  \(item.vName)")
        }
    }
    
    func reachabilityStatusChanged(){
        switch reachabilityStatus{
        case NOACCESS : view.backgroundColor = UIColor.red
            displayLabel.text = "No Internet"
        case WIFI : view.backgroundColor = UIColor.green
            displayLabel.text = "Reachable with WIFI"
        case WWAN : view.backgroundColor = UIColor.yellow
            displayLabel.text = "Reachable with Cellular"
        default : return
        }
    }
    
    // Deinit - is called just as the object is about to be de-allocated, remove the observer
    deinit {
        NotificationCenter.default.removeObserver(self, name: "reachStatusChanged" as NSNotification.Name, object: nil)
    }
    
}

