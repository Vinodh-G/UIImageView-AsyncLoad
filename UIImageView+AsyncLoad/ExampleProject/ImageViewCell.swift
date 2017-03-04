//
//  ImageViewCell.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContentView: UIImageView!
    

    func configureCellFor(_ imageURL: String)
    {
        self.imageContentView.image = nil;
        
        self.imageContentView.setImageFrom(imageURLString: imageURL, placeHolderImage: UIImage(named:"placeHolerImage")){(success : Bool, image : UIImage?, error: Error?) in
            if (success) {
            }
        }
        
//        self.imageContentView.setImageFrom(imageURLString: imageURL, progressHandler: { (expectedBytes : Int64, downloadedBytes: Int64, error : Error?) in
//            print(" \(expectedBytes / downloadedBytes * 100) : \(imageURL)")
//        }) { (success:Bool, image: UIImage?, error:Error?) in
//            
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
