//
//  ViewController.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 06/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var videos = [Videos]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // adding an observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "reachStatusChanged" as NSNotification.Name, object: nil)
        
        reachabilityStatusChanged()
        
        // call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]){
        print(reachabilityStatus)
        self.videos = videos
        for (index,item) in videos.enumerated() {
            print("\(index).  \(item.vName)")
        }
        tableView.reloadData()
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int { // Default is 1 if not implemented
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
        // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
        return videos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let video = videos[indexPath.row]
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.vName
        return cell
        
    }
    
    

    
    
}

