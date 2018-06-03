//
//  UIImageView+AsyncLoad.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import Foundation
import UIKit


protocol AsyncLoad {
    func setImageFrom(imageURLString: String,
    placeHolderImage: UIImage?,
    completionHandler: DownloadHandler?)
    
    func setImageFrom(imageURLString : String,
    placeHolderImage: UIImage?,
    progressHandler: @escaping DownloadProgressHandler,
    completionHandler: @escaping DownloadHandler)
}

typealias DownloadHandler = (_ image: UIImage?,  _ error: Error?) -> Void
typealias DownloadProgressHandler = (_ totalBytesExpected : Int64,  _ bytesDownloaded: Int64, _ error : Error?) -> Void

private var kImageURLKey : String = "imageURLKey"

extension UIImageView: AsyncLoad {
    
    var imageURLId : String{
        
        get{
            return objc_getAssociatedObject(self, &kImageURLKey) as! String
        }
        set(newValue){
            objc_setAssociatedObject(self, &kImageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImageFrom(imageURLString : String,
                      placeHolderImage: UIImage? = nil,
                      completionHandler: DownloadHandler?) {
        
        guard imageURLString.count > 0  else {
            if let handler = completionHandler {
                handler(nil, nil)
            }
            return
        }
        
        if placeHolderImage != nil {
            image = placeHolderImage;
        }
        
        imageURLId = imageURLString
        ImageDownloadManager.shared.getImageFromURL(imageURLString: imageURLString) { (image : UIImage?, error :Error?) in
            
            guard let inImage = image else {
                if let handler = completionHandler {
                    handler(nil, error)
                }
                return
            }
            
            self.updateImage(image: inImage, imageUrl: imageURLString)
            if let handler = completionHandler {
                handler(inImage, nil);
            }
        }
    }
    
    func setImageFrom(imageURLString: String,
                      placeHolderImage: UIImage? = nil,
                      progressHandler: @escaping DownloadProgressHandler,
                      completionHandler: @escaping DownloadHandler) {
        
        guard imageURLString.count > 0  else {
            completionHandler(nil, nil)
            return
        }
        
        if ((placeHolderImage) != nil){
            self.image = placeHolderImage;
        }
        self.imageURLId = imageURLString
        
        ImageDownloadManager.shared.getImageFromURL(imageURLString: imageURLString,
                                                    progessHandler: { (expectedBytes: Int64, downloadedBytes: Int64, error: Error?) in
                                                        progressHandler(expectedBytes, downloadedBytes, error)
                                                        
        }) { (image: UIImage?, error: Error?) in
            guard let inImage = image else {
                completionHandler(nil, nil)
                return
            }
            
            self.updateImage(image: inImage, imageUrl: imageURLString)
            completionHandler(inImage, error)
        }
    }
    
    private func updateImage(image:UIImage, imageUrl:String) {
        
        if (imageUrl == imageURLId)
        {
            UIView.transition(with: self,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = image;
            },
                              completion: nil)
        }
    }
}
