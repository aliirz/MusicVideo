//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 15/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class Videos {
    var vRank = 0
    // Data encapsulation
    private var _vName: String
    private var _vRights: String
    private var _vPrice: String
    private var _vImageUrl: String
    private var _vArtist: String
    private var _vVideoUrl: String
    private var _vImid: String
    private var _vGenre: String
    private var _vLinkToiTunes: String
    private var _vReleaseDate: String
    
    // This variable gets created from the UI
    var vImageData: Data?
    
    // Create getters
    var vName: String {
        return _vName
    }
    var vRights: String {
        return _vRights
    }
    var vPrice: String {
        return _vPrice
    }
    var vImageUrl: String {
        return _vImageUrl
    }
    var vArtist: String {
        return _vArtist
    }
    var vVideoUrl: String {
        return _vVideoUrl
    }
    var vImid: String {
        return _vImid
    }
    var vGenre: String {
        return _vGenre
    }
    var vLinkToiTunes: String {
        return _vLinkToiTunes
    }
    var vReleaseDate: String {
        return _vReleaseDate
    }
    
    // Initializers
    init(data: JSONDictionary) {
        // Initialize all properties, otherwise shows error 'Return from initializer without all stored properties'
        
        // Video Name
        if let name = data["im:name"] as? JSONDictionary,
            let vName = name["label"] as? String {
            self._vName = vName
        } else {
            // We may not always get data back from JSON, initialize to empty string (might also show error msg)
            _vName = ""
            print("Name Element in JSON is unexpected")
        }
        // Video Rights
        if let rights = data["rights"] as? JSONDictionary,
            let vRights = rights["label"] as? String {
            self._vRights = vRights
        } else {
            _vRights = ""
            print("Rights Element in JSON is unexpected")
        }
        // Video Price
        if let price = data["im:price"] as? JSONDictionary,
            let vPrice = price["label"] as? String {
            self._vPrice = vPrice
        } else {
            _vPrice = ""
            print("Price Element in JSON is unexpected")
        }
        // Video Image
        if let img = data["im:image"] as? JSONArray,
            let image = img[2] as? JSONDictionary,
            let immage = image["label"] as? String {
            _vImageUrl = immage.replacingOccurrences(of: "100x100", with: "600x600")
        } else {
            _vImageUrl = ""
            print("Image Element in JSON is unexpected")
        }
        // Artist
        if let artist = data["im:artist"] as? JSONDictionary,
            let vArtist = artist["label"] as? String {
            self._vArtist = vArtist
        } else {
            _vArtist = ""
            print("Artist Element in JSON is unexpected")
        }
        //Video Url
        if let video = data["link"] as? JSONArray,
            let vUrl = video[1] as? JSONDictionary,
            let vHref = vUrl["attributes"] as? JSONDictionary,
            let vVideoUrl = vHref["href"] as? String {
            self._vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
            print("Video Element in JSON is unexpected")
        }
        // vImid - The Artist ID for iTunes Search API
        if let imid = data["id"] as? JSONDictionary,
            let vid = imid["attributes"] as? JSONDictionary,
            let vImid = vid["im:id"] as? String {
            self._vImid = vImid
        } else {
            _vImid = ""
            print("IM:ID Element in JSON is unexpected")
        }
        // Genre
        if let genre = data["category"] as? JSONDictionary,
            let tmpgenre = genre["attributes"] as? JSONDictionary,
            let vGenre = tmpgenre["term"] as? String {
            self._vGenre = vGenre
        } else {
            _vGenre = ""
            print("Genre Element in JSON is unexpected")
        }
        
        // Video Link to iTunes
        if let linkToiTunes = data["id"] as? JSONDictionary,
            let vLinkToiTunes = linkToiTunes["label"] as? String {
            self._vLinkToiTunes = vLinkToiTunes
        } else {
            _vLinkToiTunes = ""
            print("Link to iTunes 'ID' Element in JSON is unexpected")
        }
        // Release Date
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary,
            let tmpreleaseDate = releaseDate["attributes"] as? JSONDictionary,
            let vReleaseDate = tmpreleaseDate["label"] as? String {
            self._vReleaseDate = vReleaseDate
        } else {
            _vReleaseDate = ""
            print("Release Date Element in JSON is unexpected")
        }
    }
}
