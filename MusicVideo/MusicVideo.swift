//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 15/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import Foundation

class Video {
    // Data encapsulation
    // by putting set, these are accessible anywhere but only set within the class (we also don't need the getters). Implementing the Single Role Responsibility Principle - the class should have single responsibility over one part of the functionality and should be entirely encapsulated by that class.
    private(set) var vRank: Int
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
    // regular initializer here
    init(vRank: Int,vName: String, vRights: String, vPrice: String, vImageUrl: String, vArtist: String, vVideoUrl: String, vImid: String, vGenre: String, vLinkToiTunes: String, vReleaseDate: String) {
        
        self.vRank = vRank
        self.vName = vName
        self.vRights = vRights
        self.vPrice = vPrice
        self.vImageUrl = vImageUrl
        self.vArtist = vArtist
        self.vVideoUrl = vVideoUrl
        self.vImid = vImid
        self.vGenre = vGenre
        self.vLinkToiTunes = vLinkToiTunes
        self.vReleaseDate = vReleaseDate

    }
}

