//
//  ImageDownloadManager.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/3/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit


struct ImageDownloadInfo {
    let downloadURLString : String
    let downloadTask : URLSessionTask
    let progressHandler : DownloadProgressHandler?
}

class ImageDownloadManager: NSObject {

    static let sharedManager : ImageDownloadManager = ImageDownloadManager()
    
    var imageLoaderQueue : [String:ImageDownloadInfo] = [:]
    var imageCache : NSCache<NSString, UIImage> = NSCache()
    
    lazy var downloadsSession : URLSession = URLSession(configuration: URLSessionConfiguration.default)
    lazy var downloadDelegateSession : URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: sharedManager, delegateQueue: OperationQueue.main)

    func getImageFromURL(imageURLString:String,
                         block:@escaping DownloadHandler) {

        let cachedImage : UIImage? = imageCache.object(forKey: imageURLString as NSString)
        
        if cachedImage != nil {
            block(true, cachedImage, nil)
        }else {
            downloadImageFor(imageURLString: imageURLString, downloadBlock: block)
        }
    }
    
    func getImageFromURL(imageURLString:String,
                         progessHandler: @escaping DownloadProgressHandler){
        let cachedImage : UIImage? = imageCache.object(forKey: imageURLString as NSString)
        
        if cachedImage != nil {
            progessHandler(1, 1, true, cachedImage)
        }else {
            
        }
    }
    
    private func downloadImageFor(imageURLString:String,
                                  downloadBlock: @escaping DownloadHandler) {
        
//        var imageLoaderTask : URLSessionDataTask? = imageLoaderQueue[imageURLString]
//        
//        if imageLoaderTask == nil {
//            
//            imageLoaderTask = downloadsSession.dataTask(with: URL(string: imageURLString)!, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
//                
//                OperationQueue.main.addOperation({
//                    
//                    if (error != nil){
//                        downloadBlock(false, nil, error)
//                    }
//                    else{
//                        let image = UIImage(data: data!)
//                        ImageDownloadManager.sharedManager.imageCache.setObject(image!, forKey: imageURLString as NSString)
//                        
//                        downloadBlock(true, image, nil)
//                    }
//                    ImageDownloadManager.sharedManager.imageLoaderQueue[imageURLString] = nil
//                })
//            })
//
//            imageLoaderQueue[imageURLString] = imageLoaderTask
//            imageLoaderTask?.resume()
//        }
        
        
        var imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageURLString]
        
        if imageDownloadInfo == nil {
            
            let imageLoaderTask = downloadsSession.dataTask(with: URL(string: imageURLString)!, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
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
            
            imageDownloadInfo = ImageDownloadInfo(downloadURLString: imageURLString,
                                                  downloadTask: imageLoaderTask,
                                                  progressHandler: nil)
            
            imageLoaderQueue[imageURLString] = imageDownloadInfo
            imageDownloadInfo?.downloadTask.resume()
        }
    }
}

extension ImageDownloadManager : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        
    }
}

