//
//  ImageDownloadManager.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/3/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit


struct ImageDownloadInfo {
    let downloadURLString: String
    let downloadTask: URLSessionTask
    let progressHandler: DownloadProgressHandler?
    let completionHandler: DownloadHandler
}

class ImageDownloadManager: NSObject {

    static let shared: ImageDownloadManager = ImageDownloadManager()
    
    var imageLoaderQueue: [String: ImageDownloadInfo] = [:]
    var imageCache: NSCache <NSString, UIImage> = NSCache()
    
    lazy var downloadsSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    lazy var downloadDelegateSession: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: ImageDownloadManager.shared, delegateQueue: OperationQueue.main)

    func getImageFromURL(imageURLString:String,
                         completionHandler:@escaping DownloadHandler) {

        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) as UIImage? {
            completionHandler(cachedImage, nil)
            return
        }
        
        downloadImageFor(imageURLString: imageURLString,
                         downloadHandler: completionHandler)
    }
    
    func getImageFromURL(imageURLString:String,
                         progessHandler: @escaping DownloadProgressHandler,
                         completionHandler: @escaping DownloadHandler ){
        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) as UIImage? {
            completionHandler(cachedImage, nil)
            return
        }
        
        downloadImageFor(imageURLString: imageURLString,
                         progressHandler: progessHandler,
                         completionHandler: completionHandler)
    }
    
    private func downloadImageFor(imageURLString:String,
                                  downloadHandler: @escaping DownloadHandler) {
        
        var imageDownloadInfo: ImageDownloadInfo? = imageLoaderQueue[imageURLString]
        
        if imageDownloadInfo == nil {
            
            let imageLoaderTask = downloadsSession.dataTask(with: URL(string: imageURLString)!, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                
                OperationQueue.main.addOperation({
                    
                    guard let validData = data else {
                        downloadHandler(nil, error)
                        return;
                    }
                    
                    guard let image = UIImage(data: validData) else {
                        downloadHandler(nil, error)
                        return;
                    }
                    
                    self.imageCache.setObject(image, forKey: imageURLString as NSString)
                    downloadHandler(image, nil)
                    self.imageLoaderQueue[imageURLString] = nil
                })
            })
            
            imageDownloadInfo = ImageDownloadInfo(downloadURLString: imageURLString,
                                                  downloadTask: imageLoaderTask,
                                                  progressHandler: nil,
                                                  completionHandler: downloadHandler)
            
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
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){

        
        guard let imageUrl: String = downloadTask.originalRequest?.url?.absoluteString else {
            return
        }
        
        guard let imageDownloadInfo: ImageDownloadInfo = imageLoaderQueue[imageUrl] else {
            return
        }
        do {
            let data = try Data(contentsOf: location)
            guard let image = UIImage(data: data) else {
                let handler = imageDownloadInfo.completionHandler
                handler(nil, nil)
                return
            }
            ImageDownloadManager.shared.imageCache.setObject(image, forKey: imageUrl as NSString)
            let handler = imageDownloadInfo.completionHandler
            handler(image, nil)
            
        } catch {
            let handler = imageDownloadInfo.completionHandler
            handler(nil, nil)
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

