//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 15/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class Video {
    var vRank = 0
    // Data encapsulation
    // by putting set, these are accessible anywhere but only set within the class (we also don't need the getters). Single Responsibility Principle?
    private(set) var vName: String
    private(set) var vRights: String
    private(set) var vPrice: String
    private(set) var vImageUrl: String
    private(set) var vArtist: String
    private(set) var vVideoUrl: String
    private(set) var vImid: String
    private(set) var vGenre: String
    private(set) var vLinkToiTunes: String
    private(set) var vReleaseDate: String
    
    // This variable gets created from the UI
    var vImageData: Data?
    
    // Initializers
    init(data: JSONDictionary) { // initialize here
        self.vName = ""
        self.vRights = ""
        self.vPrice = ""
        self.vImageUrl = ""
        self.vArtist = ""
        self.vVideoUrl = ""
        self.vImid = ""
        self.vGenre = ""
        self.vLinkToiTunes = ""
        self.vReleaseDate = ""
        
        // Video Name
        if let name = data["im:name"] as? JSONDictionary,
            let vName = name["label"] as? String {
            self.vName = vName
        } else {
            // We may not always get data back from JSON, show error msg
            print("Name Element in JSON is unexpected")
        }
        // Video Rights
        if let rights = data["rights"] as? JSONDictionary,
            let vRights = rights["label"] as? String {
            self.vRights = vRights
        } else {
            print("Rights Element in JSON is unexpected")
        }
        // Video Price
        if let price = data["im:price"] as? JSONDictionary,
            let vPrice = price["label"] as? String {
            self.vPrice = vPrice
        } else {
            print("Price Element in JSON is unexpected")
        }
        // Video Image
        if let img = data["im:image"] as? JSONArray,
            let image = img[2] as? JSONDictionary,
            let immage = image["label"] as? String {
            vImageUrl = immage.replacingOccurrences(of: "100x100", with: "600x600")
        } else {
            print("Image Element in JSON is unexpected")
        }
        // Artist
        if let artist = data["im:artist"] as? JSONDictionary,
            let vArtist = artist["label"] as? String {
            self.vArtist = vArtist
        } else {
            print("Artist Element in JSON is unexpected")
        }
        //Video Url
        if let video = data["link"] as? JSONArray,
            let vUrl = video[1] as? JSONDictionary,
            let vHref = vUrl["attributes"] as? JSONDictionary,
            let vVideoUrl = vHref["href"] as? String {
            self.vVideoUrl = vVideoUrl
        } else {
            print("Video Element in JSON is unexpected")
        }
        // vImid - The Artist ID for iTunes Search API
        if let imid = data["id"] as? JSONDictionary,
            let vid = imid["attributes"] as? JSONDictionary,
            let vImid = vid["im:id"] as? String {
            self.vImid = vImid
        } else {
            print("IM:ID Element in JSON is unexpected")
        }
        // Genre
        if let genre = data["category"] as? JSONDictionary,
            let tmpgenre = genre["attributes"] as? JSONDictionary,
            let vGenre = tmpgenre["term"] as? String {
            self.vGenre = vGenre
        } else {
            print("Genre Element in JSON is unexpected")
        }
        // Video Link to iTunes
        if let linkToiTunes = data["id"] as? JSONDictionary,
            let vLinkToiTunes = linkToiTunes["label"] as? String {
            self.vLinkToiTunes = vLinkToiTunes
        } else {
            print("Link to iTunes 'ID' Element in JSON is unexpected")
        }
        // Release Date
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary,
            let tmpreleaseDate = releaseDate["attributes"] as? JSONDictionary,
            let vReleaseDate = tmpreleaseDate["label"] as? String {
            self.vReleaseDate = vReleaseDate
        } else {
            print("Release Date Element in JSON is unexpected")
        }
    }
}
