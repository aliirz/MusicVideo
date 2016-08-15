//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 15/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class Videos {
    // Data Encapsulation
    private var _vName:String
    private var _vImageUrl:String
    private var _vVideoUrl:String
    
    // make a getter
    var vName:String{
        return _vName
    }
    var vImageUrl:String{
        return _vImageUrl
    }
    var vVideoUrl:String{
        return _vVideoUrl
    }
    
    // Initializers
    init(data: JSONDictionary) {
        // Initialize all properties, otherwise shows error 'Return from initializer without all stored properties'
        
        // Video Name
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
            self._vName = vName
        } else {
            // We may ont always get data back from JSON, initialize to empty string (might also wish to show error msg)
            _vName = ""
            print("Name Element in JSON is unexpected")
        }
        
        // Video Image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
            _vImageUrl = String(immage.replacingOccurrences(of: "100x100", with: "100x100"))
        } else {
            _vImageUrl = ""
            print("Image Element in JSON is unexpected")
        }
        
        // Video Image
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
            self._vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
            print("Video Element in JSON is unexpected")
            
        }
        
        
    }
    
}

