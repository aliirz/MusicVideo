//
//  APIManager.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 08/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString:String, completion: (result:String) -> Void) {
        let config = URLSessionConfiguration.ephemeral()
        let session = URLSession(configuration: config)
        //let session = URLSession.shared()
        let url = NSURL(string: urlString)!
        let task = session.dataTask(with: url as URL) { (data, response, error) -> Void in
            DispatchQueue.main.asynchronously(){
                if error != nil {
                    completion(result: (error!.localizedDescription))
                } else {
                    completion(result: "URLSession successful")
                    print(data)
                }
            }
        }
        task.resume()
    }
}

    /*
    func loadData(urlString:String, completion: (result:String) -> Void ) {
        let config = URLSessionConfiguration.ephemeral()
        let session = URLSession(configuration: config)
        //        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        
        let task = session.dataTask(with: url as URL) {
            (data, response, error) -> Void in
            
            DispatchQueue.main.asynchronously() {
                if error != nil {
                    completion(result: (error!.localizedDescription))
                } else {
                    completion(result: "NSURLSession successful")
                    print(data)
                }
            }
        }
        task.resume()
    }
 
}
*/
