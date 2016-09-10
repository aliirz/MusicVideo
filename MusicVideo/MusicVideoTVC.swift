//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 21/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {
// no protocol here, using class extention in MyExtensions to use delegate
    
    var videos = [Videos]()
    var filterSearch = [Videos]()
    var limit = 10
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observers
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "reachStatusChanged" as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange as NSNotification.Name, object: nil)
        
        reachabilityStatusChanged()
    }
    
    func preferredFontChange(){
        print("The preferred font has changed")
    }
    
    func didLoadData(videos: [Videos]){
        print(reachabilityStatus)
        self.videos = videos
        for (index,item) in videos.enumerated() {
            print("\(index).  \(item.vName)")
        }
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        title = ("The iTunes top \(limit) Music Videos")
        
        // set up the search controller
        resultSearchController.searchResultsUpdater = self  // setting up with protocol
        definesPresentationContext = true   // ensure search bar removed when going to other screens
        resultSearchController.dimsBackgroundDuringPresentation = false  // very important, and a typical gotcha- where if not set up correctly won't allow to go to search results
        resultSearchController.searchBar.placeholder = "Search for a song, artist or rank"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        // add the search bar to tableview
        tableView.tableHeaderView = resultSearchController.searchBar
                
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged(){
        switch reachabilityStatus{
        case NOACCESS :
            // view.backgroundColor = UIColor.red
            
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
            let okAction = UIAlertAction(title: "OK", style: .default) {
                action -> () in
                print("OK")
                
                // do something if we want further action
                // alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        default:
            // view.backgroundColor = UIColor.green
            // no need to run API after Internet status change if video list is already populated
            if videos.count > 0 {
                print("Do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        refreshControl?.endRefreshing() // stop the spinner
        if resultSearchController.isActive { // don't refresh when inside the search results
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
            runAPI()
        }
    }
    
    // Fetch slider count from UserDefaults
    func getAPICount() {
        if UserDefaults.standard.object(forKey: "APICount") != nil {
            let theValue = UserDefaults.standard.object(forKey: "APICount") as! Int
            limit = theValue
        }
        
        // format date
        // additional reading: http://www.globalnerdy.com/2016/08/22/how-to-work-with-dates-and-times-in-swift-3-part-2-dateformatter/
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "E, dd MMM yyyy   HH:mm:ss"
        let refreshDate = myFormatter.string(from: NSDate() as Date) // forced cast always succeeds, no unwrapping required
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    // call API
    func runAPI(){
        getAPICount()   // how many videos to get from iTunes
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    // Deinit - remove observers as object is de-allocated
    deinit {
        NotificationCenter.default.removeObserver(self, name: "reachStatusChanged" as NSNotification.Name, object: nil)
        NotificationCenter.default.removeObserver(self, name: "preferredFontChange" as NSNotification.Name, object: nil)
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
        static let sequeIdentifier = "musicDetail"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.isActive {
            cell.video = filterSearch[indexPath.row]
            
        } else {
            cell.video = videos[indexPath.row]
        }
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.sequeIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video : Videos
                
                if resultSearchController.isActive {
                    video = filterSearch[indexPath.row]
                } else {
                    video = videos[indexPath.row]
                }
                
                let dvc = segue.destination as! MusicVideoDetailVC
                dvc.videos = video
                
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    // put the protocol implementation as a class extension
//    func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchBar.text!.lowercased()
//        filterSearch(searchController.searchBar.text!)
//    }
    
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return  videos.vArtist.lowercased().contains(searchText.lowercased()) ||
                    videos.vName.lowercased().contains(searchText.lowercased()) ||
                    String(videos.vRank).lowercased().contains(searchText.lowercased())
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
