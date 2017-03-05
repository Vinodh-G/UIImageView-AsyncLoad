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
