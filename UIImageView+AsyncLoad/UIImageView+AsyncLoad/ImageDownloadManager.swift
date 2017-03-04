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
    let completionHandler : DownloadHandler?
}

class ImageDownloadManager: NSObject {

    static let sharedManager : ImageDownloadManager = ImageDownloadManager()
    
    var imageLoaderQueue : [String:ImageDownloadInfo] = [:]
    var imageCache : NSCache<NSString, UIImage> = NSCache()
    
    lazy var downloadsSession : URLSession = URLSession(configuration: URLSessionConfiguration.default)
    lazy var downloadDelegateSession : URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: sharedManager, delegateQueue: OperationQueue.main)

    func getImageFromURL(imageURLString:String,
                         completionHandler:@escaping DownloadHandler) {

        let cachedImage : UIImage? = imageCache.object(forKey: imageURLString as NSString)
        
        if cachedImage != nil {
            completionHandler(true, cachedImage, nil)
        }else {
            downloadImageFor(imageURLString: imageURLString, downloadHandler: completionHandler)
        }
    }
    
    func getImageFromURL(imageURLString:String,
                         progessHandler: @escaping DownloadProgressHandler,
                         completionHandler: @escaping DownloadHandler ){
        let cachedImage : UIImage? = imageCache.object(forKey: imageURLString as NSString)
        
        if cachedImage != nil {
            progessHandler(1, 1, nil)
            completionHandler(true, cachedImage, nil)
        }else {
            downloadImageFor(imageURLString: imageURLString, progressHandler: progessHandler, completionHandler:completionHandler)
        }
    }
    
    private func downloadImageFor(imageURLString:String,
                                  downloadHandler: @escaping DownloadHandler) {
        
        
        var imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageURLString]
        
        if imageDownloadInfo == nil {
            
            let imageLoaderTask = downloadsSession.dataTask(with: URL(string: imageURLString)!, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                OperationQueue.main.addOperation({
                    
                    if (error != nil){
                        downloadHandler(false, nil, error)
                    }
                    else{
                        let image = UIImage(data: data!)
                        ImageDownloadManager.sharedManager.imageCache.setObject(image!, forKey: imageURLString as NSString)
                        
                        downloadHandler(true, image, nil)
                    }
                    ImageDownloadManager.sharedManager.imageLoaderQueue[imageURLString] = nil
                })
            })
            
            imageDownloadInfo = ImageDownloadInfo(downloadURLString: imageURLString,
                                                  downloadTask: imageLoaderTask,
                                                  progressHandler: nil,
                                                  completionHandler:nil)
            
            imageLoaderQueue[imageURLString] = imageDownloadInfo
            imageDownloadInfo?.downloadTask.resume()
        }
    }
    
    private func downloadImageFor(imageURLString:String,
                                  progressHandler: @escaping DownloadProgressHandler,
                                  completionHandler: @escaping DownloadHandler) {
        
        var imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageURLString]
        
        if imageDownloadInfo == nil {
            
            let imageLoaderTask = downloadDelegateSession.downloadTask(with: URL(string: imageURLString)!)
            
            imageDownloadInfo = ImageDownloadInfo(downloadURLString: imageURLString,
                                                  downloadTask: imageLoaderTask,
                                                  progressHandler: progressHandler,
                                                  completionHandler:completionHandler)
            
            imageLoaderQueue[imageURLString] = imageDownloadInfo
            imageDownloadInfo?.downloadTask.resume()
        }
        
    }
}

extension ImageDownloadManager : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
        let imageUrl : String = (downloadTask.originalRequest?.url?.absoluteString)!
        let imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageUrl]
        
        if imageDownloadInfo != nil {
            
            
            do {
                let data = try Data(contentsOf: location)
                
                let image = UIImage(data: data)
                
                ImageDownloadManager.sharedManager.imageCache.setObject(image!, forKey: imageUrl as NSString)
                
                if let completionHandler = imageDownloadInfo?.completionHandler {
                 
                    completionHandler(true, image, nil)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
        let imageUrl = downloadTask.originalRequest?.url?.absoluteString
        let imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageUrl!]

        if imageDownloadInfo != nil {
            
            if let progressHandler = imageDownloadInfo?.progressHandler {
                progressHandler(totalBytesExpectedToWrite, totalBytesWritten, nil)
            }
        }
    }
    
}

