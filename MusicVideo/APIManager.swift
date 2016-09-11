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
    
    func loadData(urlString:String, completion: ([Video]) -> Void ) {
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        let url = NSURL(string: urlString)!
        
        let task = session.dataTask(with: url as URL) {
            (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let videos = self.parseJSON(data: data)
                
                let priority = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
                priority.async {
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
    // Parse JSON Data
    func parseJSON(data: Data?) -> [Video] {
        do {
            if let JSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject? {
                return JSONDataExtractor.extractVideoDataFromJSON(videoDataObject: JSON)
            }
        }
        catch {
            print("Failed to parse data: \(error)")
        }
        return [Video]()
    }
}
