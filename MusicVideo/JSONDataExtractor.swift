//
//  JSONDataExtractor.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 11/09/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class JSONDataExtractor {
    
    static func extractVideoDataFromJSON(videoDataObject: AnyObject) ->[Video] {
        
        guard let videoData = videoDataObject as? JSONDictionary else {return [Video]() }
        
        var videos = [Video]()
        
        if let feeds = videoData["feed"] as? JSONDictionary, let entries = feeds["entry"] as? JSONArray {
            
            for (index, data) in entries.enumerated() {
                var vName = "", vRights = "", vPrice = "", vImageUrl = "", vArtist = "", vVideoUrl = "", vImid = "", vGenre = "", vLinkToiTunes = "", vReleaseDate = ""
                
                
                
                // Video Name
                if let imName = data["im:name"] as? JSONDictionary,
                    let label = imName["label"] as? String {
                    vName = label
                } else {
                    // We may not always get data back from JSON, show error msg
                    print("Name Element in JSON is unexpected")
                }
                // Video Rights
                if let rightsDict = data["rights"] as? JSONDictionary,
                    let label = rightsDict["label"] as? String {
                    vRights = label
                } else {
                    print("Rights Element in JSON is unexpected")
                }
                // Video Price
                if let imPrice = data["im:price"] as? JSONDictionary,
                    let label = imPrice["label"] as? String {
                    vPrice = label
                } else {
                    print("Price Element in JSON is unexpected")
                }
                // Video Image
                if let imImage = data["im:image"] as? JSONArray,
                    let image = imImage[2] as? JSONDictionary,
                    let label = image["label"] as? String {
                    vImageUrl = label.replacingOccurrences(of: "100x100", with: "600x600")
                } else {
                    print("Image Element in JSON is unexpected")
                }
                // Artist
                if let imArtist = data["im:artist"] as? JSONDictionary,
                    let label = imArtist["label"] as? String {
                    vArtist = label
                } else {
                    print("Artist Element in JSON is unexpected")
                }
                //Video Url
                if let link = data["link"] as? JSONArray,
                    let vUrl = link[1] as? JSONDictionary,
                    let attributes = vUrl["attributes"] as? JSONDictionary,
                    let href = attributes["href"] as? String {
                    vVideoUrl = href
                } else {
                    print("Video Element in JSON is unexpected")
                }
                // vImid - The Artist ID for iTunes Search API
                if let id = data["id"] as? JSONDictionary,
                    let attributes = id["attributes"] as? JSONDictionary,
                    let imid = attributes["im:id"] as? String {
                    vImid = imid
                } else {
                    print("IM:ID Element in JSON is unexpected")
                }
                // Genre
                if let category = data["category"] as? JSONDictionary,
                    let attributes = category["attributes"] as? JSONDictionary,
                    let term = attributes["term"] as? String {
                    vGenre = term
                } else {
                    print("Genre Element in JSON is unexpected")
                }
                // Video Link to iTunes
                if let id = data["id"] as? JSONDictionary,
                    let label = id["label"] as? String {
                    vLinkToiTunes = label
                } else {
                    print("Link to iTunes 'ID' Element in JSON is unexpected")
                }
                // Release Date
                if let imReleaseDate = data["im:releaseDate"] as? JSONDictionary,
                    let attributes = imReleaseDate["attributes"] as? JSONDictionary,
                    let label = attributes["label"] as? String {
                    vReleaseDate = label
                } else {
                    print("Release Date Element in JSON is unexpected")
                }
                
                // Using the initalizer from our class, append to the array
                let currentVideo = Video(vRank: index + 1, vName: vName, vRights: vRights, vPrice: vPrice, vImageUrl: vImageUrl, vArtist: vArtist, vVideoUrl: vVideoUrl, vImid: vImid, vGenre: vGenre, vLinkToiTunes: vLinkToiTunes, vReleaseDate: vReleaseDate)
                
                videos.append(currentVideo)
                
            }
        }
        return videos
    }
}
