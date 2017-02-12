//
//  ImageDownloadManager.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/3/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit


class ImageDownloadManager: NSObject {

    static let sharedManager : ImageDownloadManager = ImageDownloadManager()
    
    var imageLoaderQueue : [String:URLSessionDataTask] = [:]
    var imageCache : NSCache<NSString, UIImage> = NSCache()
    
    lazy var downloadsSession : URLSession = URLSession(configuration: URLSessionConfiguration.default)

    func getImageFromURL(imageURLString:String,
                         block:@escaping DownloadHandler) {

        let cachedImage : UIImage? = imageCache.object(forKey: imageURLString as NSString)
        
        if cachedImage != nil {
            block(true, cachedImage, nil)
        }else {
            downloadImageFor(imageURLString: imageURLString, downloadBlock: block)
        }
    }
    
    
    private func downloadImageFor(imageURLString:String,
                                  downloadBlock: @escaping DownloadHandler) {
        
        var imageLoaderTask : URLSessionDataTask? = imageLoaderQueue[imageURLString]
        
        if imageLoaderTask == nil {
            
            imageLoaderTask = downloadsSession.dataTask(with: URL(string: imageURLString)!, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                OperationQueue.main.addOperation({
                    
                    if (error != nil){
                        downloadBlock(false, nil, error)
                    }
                    else{
                        let image = UIImage(data: data!)
                        ImageDownloadManager.sharedManager.imageCache.setObject(image!, forKey: imageURLString as NSString)
                        
                        downloadBlock(true, image, nil)
                    }
                    ImageDownloadManager.sharedManager.imageLoaderQueue[imageURLString] = nil
                })
            })
            
            imageLoaderQueue[imageURLString] = imageLoaderTask
            imageLoaderTask?.resume()
        }
    }
}

