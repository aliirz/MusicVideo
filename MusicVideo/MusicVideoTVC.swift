//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 21/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {

    var videos = [Videos]()
    
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
    
    // call API
    func runAPI(){
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=200/json", completion: didLoadData)
    }
    
    // Deinit - is called just as the object is about to be de-allocated, remove observers
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
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.cellReuseIdentifier, for: indexPath) as! MusicVideoTableViewCell

        cell.video = videos[indexPath.row]
        
        // Configure the cell...
        // below is not needed any more, as we use above the public api access through cell.video
        // let video = videos[indexPath.row]
        // cell.textLabel?.text = ("\(indexPath.row + 1)")
        // cell.detailTextLabel?.text = video.vName
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
