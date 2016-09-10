//
//  ViewController.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 06/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//
// Object Oriented Programming resources: https://www.raywenderlich.com/81952/intro-object-oriented-design-swift-part-1
// size classes: https://developer.apple.com/videos/play/wwdc2016/222/


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var videos = [Videos]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // add observers
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged" as NSNotification.Name, object: nil)
        
        reachabilityStatusChanged()
        
        
        //Call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json", completion: didLoadData)
    }
    
    func didLoadData(_ videos: [Videos]) {
        print(reachabilityStatus)
        self.videos = videos
        for (index, item) in videos.enumerated() {
            print("\(index)  \(item.vName)")
        }
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS : view.backgroundColor = UIColor.red
        displayLabel.text = "No Internet"
        case WIFI : view.backgroundColor = UIColor.green
        displayLabel.text = "Reachable with WIFI"
        case WWAN : view.backgroundColor = UIColor.yellow
        displayLabel.text = "Reachable with Cellular"
        default:return
        }
    }
    
    // Deinit - remove observers as object gets de-allocated
    deinit {
        NotificationCenter.default.removeObserver(self, name: "ReachStatusChanged" as NSNotification.Name, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{ // Default is 1 if not implemented
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let video = videos[indexPath.row]
        let video = videos[(indexPath as NSIndexPath).row]
        // cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.textLabel?.text = ("\((indexPath as NSIndexPath).row + 1)")
        
        cell.detailTextLabel?.text = video.vName
        
        return cell
    }

}
