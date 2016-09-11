//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 21/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//
// Object Oriented Programming resources: https://www.raywenderlich.com/81952/intro-object-oriented-design-swift-part-1
// size classes: https://developer.apple.com/videos/play/wwdc2016/222/
//

import UIKit

class MusicVideoTVC: UITableViewController {
    // no protocol used here, using class extention in MyExtensions to use delegates
    var videos = [Video]()
    var filterSearch = [Video]()
    let resultSearchController = UISearchController(searchResultsController: nil)
    var limit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observers
        NotificationCenter.default.addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged" as NSNotification.Name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicVideoTVC.preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        
        reachabilityStatusChanged()
        
    }
    
    func preferredFontChange() {
        print("The preferred Font has changed")
    }
    
    func didLoadData(_ videos: [Video]) {
        print(reachabilityStatus)
        self.videos = videos
        for (index, item) in videos.enumerated() {
            print("\(index).  \(item.vName)")
        }
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        title = ("The iTunes Top \(limit) Music Videos")
        
        // Setup the Search Controller
        resultSearchController.searchResultsUpdater = self // setting up with protocol or extention
        definesPresentationContext = true // ensure search bar removed when going to other screens 
        resultSearchController.dimsBackgroundDuringPresentation = false // IMP: set this up correctly ensure search results are clickable and user can go to other screens.
        resultSearchController.searchBar.placeholder = "Search for a Song, Artist or Rank"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        // add the search bar to tableview
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS :
            //view.backgroundColor = UIColor.red
            
            // move back to Main Queue
            DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .alert)
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                    action -> () in
                    print("Cancel")
                }
                
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                    action -> () in
                    print("Delete")
                }
                let okAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                    print("Ok")
                    
                    // do something if we want further action
                    // alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        default:
            //view.backgroundColor = UIColor.green
            // no need to run API after Internet status change if video list is already populated
            if videos.count > 0 {
                print("Do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func getAPICount() {
        
        if (UserDefaults.standard.object(forKey: "APICNT") != nil)
        {
            let theValue = UserDefaults.standard.object(forKey: "APICNT") as! Int
            limit = theValue
        }
        
        // format date
        // additional reading: http://www.globalnerdy.com/2016/08/22/how-to-work-with-dates-and-times-in-swift-3-part-2-dateformatter/
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "E, dd MMM yyyy    HH:mm:ss"
        let refreshDate = myFormatter.string(from: Date()) // forced cast of a date always succeeds, no unwrapping required
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        
        refreshControl?.endRefreshing()
        
        if resultSearchController.isActive {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
            runAPI()
        }
    }
    // Run API
    func runAPI() {
        getAPICount()  // how many videos to get from iTunes
        let api = APIManager() //Call API
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    // Deinit - remove observers as object is de-allocated
    deinit {
        NotificationCenter.default.removeObserver(self, name: "ReachStatusChanged" as NSNotification.Name, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filterSearch.count
        }
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.isActive {
            // cell.video = filterSearch[indexPath.row]
            cell.video = filterSearch[(indexPath as NSIndexPath).row]
        } else {
            // cell.video = videos[indexPath.row]
            cell.video = videos[(indexPath as NSIndexPath).row]
        }
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    // preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier
        {
            if let indexpath = tableView.indexPathForSelectedRow {
                let video: Video
                
                if resultSearchController.isActive {
                    // video = filterSearch[indexPath.row]
                    video = filterSearch[(indexpath as NSIndexPath).row]
                    
                } else {
                    // video = videos[indexPath.row]
                    video = videos[(indexpath as NSIndexPath).row]
                }
                
                let dvc = segue.destination as! MusicVideoDetailVC
                dvc.videos = video
                
            }
        }
    }
    
    // We have put the protocol implementation as a class extension
    //    func updateSearchResults(for searchController: UISearchController) {
    //        searchController.searchBar.text!.lowercased()
    //        filterSearch(searchController.searchBar.text!)
    //    }
    
    func filterSearch(_ searchText: String) {
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercased().contains(searchText.lowercased()) || videos.vName.lowercased().contains(searchText.lowercased()) || "\(videos.vRank)".lowercased().contains(searchText.lowercased()) // rank converted to String from Int
        }
        tableView.reloadData()
    }
}

//extension MusicVideoTVC: UISearchResultsUpdating {
//func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchBar.text!.lowercased()
//    filterSearch(searchController.searchBar.text!)
//    }
//}

// TO CONSIDER: lower resolution images if connection is not WiFi or best res switch not on.

