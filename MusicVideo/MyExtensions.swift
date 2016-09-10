//
//  MyExtensions.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 10/09/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

extension MusicVideoTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    searchController.searchBar.text!.lowercased()
        filterSearch(searchController.searchBar.text!)
    }
}
