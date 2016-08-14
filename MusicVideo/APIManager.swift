//  APIManager.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 08/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.

import Foundation

class APIManager {
    

    func loadData(urlString:String, completion: (result:String) -> Void ) {
            let config = URLSessionConfiguration.ephemeral()
            let session = URLSession(configuration: config)
            let url = NSURL(string: urlString)!
            
            let task = session.dataTask(with: url as URL) {
                (data, response, error) -> Void in
                if error != nil {
                    DispatchQueue.main.asynchronously() {
                        completion(result: (error!.localizedDescription))
                    }
        
                } else {
                    
                    // JSONSerialization
                
                    do {
                        /* .allowFragments - to continue processing in case top level object is not Array or Dictionary. Using JSONSerialization with the Do / Try / Catch, converts the NSDATA into a JSON Object and cast it to a Dictionary */
                    
                        if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: AnyObject] {
                            
                            print(json)
                            
                            let priority = DispatchQueue.GlobalAttributes.qosUserInitiated
                            DispatchQueue.global(attributes: priority).asynchronously() {
                                DispatchQueue.main.asynchronously() {
                                    completion(result: "JSONSerialization Successful")
                                }
                            }
                        }
                        
                    } catch {
                        DispatchQueue.main.asynchronously() {
                            completion(result: "error in JSONSerialization")
                        }
                    }
                    //End of JSONSerialization
                }
            }
            
            task.resume()
        }
}

