//
//  DataManager.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit

final class DataManager: NSObject {

    static let sharedInstance: DataManager = DataManager()

    
    func getImageURLS() -> [String]
    {
        let imageUrls = ["http://freebigpictures.com/wp-content/uploads/2009/09/fall-leaves.jpg",
                     "http://freebigpictures.com/wp-content/uploads/2009/09/autumn-forest.jpg",
                     "http://freebigpictures.com/wp-content/uploads/veronica-chamaedrys.jpg",
                     "http://freebigpictures.com/wp-content/uploads/2009/09/yellow-wildflower.jpg",
                     "http://freebigpictures.com/wp-content/uploads/rainbow-over-forest.jpg",
                     "http://freebigpictures.com/wp-content/uploads/2009/09/blooming-forest.jpg",
                     "http://freebigpictures.com/wp-content/uploads/2009/09/river-path.jpg",
                     "http://www.hdwallpapers.in/walls/rogue_one_a_star_wars_story_4k_8k-wide.jpg",
        ]
        
        return imageUrls
    }
}
