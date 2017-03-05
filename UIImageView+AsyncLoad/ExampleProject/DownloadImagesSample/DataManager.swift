//
//  DataManager.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit

final class DataManager: NSObject {
    
    public static let shared : DataManager = {
        let instance = DataManager()
        instance.getPhotos()
        return instance
    }()
    
//    func getImageURLS() -> [String]
//    {
//        let imageUrls = ["http://freebigpictures.com/wp-content/uploads/2009/09/fall-leaves.jpg || https://api.thumbalizr.com/?url=http%3A%2F%2Ffreebigpictures.com%2Fwp-content%2Fuploads%2F2009%2F09%2Ffall-leaves.jpg&api_key=&width=640&quality=80&encoding=jpg",
//                         
//                     "http://freebigpictures.com/wp-content/uploads/2009/09/autumn-forest.jpg || https://api.thumbalizr.com/?url=http%3A%2F%2Ffreebigpictures.com%2Fwp-content%2Fuploads%2F2009%2F09%2Fautumn-forest.jpg&api_key=&width=640&quality=80&encoding=jpg",
//                     "http://freebigpictures.com/wp-content/uploads/veronica-chamaedrys.jpg",
//                     "http://freebigpictures.com/wp-content/uploads/2009/09/yellow-wildflower.jpg",
//                     "http://freebigpictures.com/wp-content/uploads/rainbow-over-forest.jpg",
//                     "http://freebigpictures.com/wp-content/uploads/2009/09/blooming-forest.jpg",
//                     "http://freebigpictures.com/wp-content/uploads/2009/09/river-path.jpg",
//                     "http://www.hdwallpapers.in/walls/rogue_one_a_star_wars_story_4k_8k-wide.jpg",
//        ]
//        
//        return imageUrls
//    }
    
    var photos: NSMutableArray = []
    
    func getPhotos(){
        
        let filePath = Bundle.main.path(forResource: "ImagesList.plist", ofType: "")
        let photoList : NSArray = NSArray(contentsOfFile: filePath!)!
        
        for photoDetail in photoList {
            let inPhotoDetails = photoDetail as! Dictionary<String,String>
            let photo = Photo(name: inPhotoDetails["Name"]!, description: inPhotoDetails["Description"]!, tumbnailUrl: inPhotoDetails["ThumnailUrl"]!, originalURl: inPhotoDetails["OriginalUrl"]!)
            
            photos.add(photo)
        }
    }
    
    func numberOfPhotos() -> Int{
        return photos.count
    }
    
    func photoAt(index: Int) -> Photo?{
    
        var photo: Photo? = nil
        if index < photos.count
        {
            photo = photos[index] as? Photo
        }
        return photo
    }
}
