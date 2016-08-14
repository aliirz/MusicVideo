//
//  ViewController.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 06/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)    // TODO: error here: value of type 'APIManager' has no member 'loadData' // do we need to cast it explicitly?
    }
    
    func didLoadData(result:String){
        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            // Do something if we want
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

