//
//  UIImageView+AsyncLoad.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import Foundation
import UIKit

typealias DownloadHandler = (_ success: Bool,  _ image: UIImage?,  _ error: Error?) -> Void
typealias DownloadProgressHandler = (_ bytesDownloaded: Int64,  _ totalBytesExpected: Int64,  _ completed: Bool, _ image : UIImage?) -> Void

private var kImageURLKey : String = "imageURLKey"

extension UIImageView{
    
    var imageURLId : String{
        
        get{
            return objc_getAssociatedObject(self, &kImageURLKey) as! String
        }
        set(newValue){
            objc_setAssociatedObject(self, &kImageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImageFrom(imageURLString : String, placeHolderImage: UIImage? = nil, completionHandler: DownloadHandler?) {
        
        if (imageURLString.characters.count > 0){
            
            if ((placeHolderImage) != nil){
                self.image = placeHolderImage;
            }
            
            self.imageURLId = imageURLString
            
            ImageDownloadManager.sharedManager.getImageFromURL(imageURLString: imageURLString) {(success : Bool, image : UIImage?, error :Error?) in
                
                if (success){
                    self.updateImage(image: image!, imageUrl: imageURLString)
                }
                
                if ((completionHandler) != nil){
                    completionHandler!(success, image, error)
                }
            }
        }
    }
    
    func setImageFrom(imageURLString : String, placeHolderImage: UIImage? = nil, progressHandler: DownloadProgressHandler?) {
        
        if (imageURLString.characters.count > 0){
            
            if ((placeHolderImage) != nil){
                self.image = placeHolderImage;
            }
            
            self.imageURLId = imageURLString
            
            
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
