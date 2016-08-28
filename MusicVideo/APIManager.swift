//  APIManager.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 08/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.

// Note: For multi-threaded application, GCD, DispatchQueue, check
// https://www.youtube.com/watch?v=zfCZTnEZ6Dw
// https://www.youtube.com/watch?v=EGUpFGwP1hM
// https://www.youtube.com/watch?v=kVPVJrAmSAs

import Foundation

class APIManager {
    

    func loadData(urlString:String, completion: ([Videos]) -> Void ) {
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config)
            let url = NSURL(string: urlString)!
            
            let task = session.dataTask(with: url as URL) {
                (data, response, error) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    
                    // JSONSerialization
                
                    do {
                        /* .allowFragments - to continue processing in case top level object is not Array or Dictionary. Using JSONSerialization with the Do / Try / Catch, converts the NSDATA into a JSON Object and cast it to a Dictionary */
                    
                        if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? JSONDictionary,
                        let feed = json["feed"] as? JSONDictionary,
                        let entries = feed["entry"] as? JSONArray {
                            
                            var videos = [Videos]()
                            for (index,entry) in entries.enumerated() {
                                let entry = Videos(data: entry as! JSONDictionary)
                                entry.vRank = index + 1
                                videos.append(entry)
                            }
                            
                            let i = videos.count
                            print("iTunesAPIManager - Total count --> \(i)")
                            print(" ")
                            
                            let priority = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
                            priority.async {
                                DispatchQueue.main.async {
                                    completion(videos)
                                }
                            }
                        }
                        
                    } catch {
                        print("error in JSONSerialization")
                    }
                    //End of JSONSerialization
                }
            }
            
            task.resume()
        }
}

