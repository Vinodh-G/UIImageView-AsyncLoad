//
//  ImagesCollectionViewController.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCellId"

class ImagesCollectionViewController: UICollectionViewController {

    
    
    var dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataManager.numberOfPhotos()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageViewCell
    

        configureCell(cell: cell, forPhoto: dataManager.photoAt(index: indexPath.row)!)
        
        return cell
    }
    
    
    func configureCell(cell : ImageViewCell, forPhoto:Photo){
        
//        cell.configureCellFor(forPhoto.tumbnailUrl)
        cell.titleLabel.text = forPhoto.name;
        cell.descriptionLabel.text = forPhoto.description
        cell.imageContentView.setImageFrom(imageURLString: forPhoto.tumbnailUrl, placeHolderImage: UIImage(named:"placeHolerImage"), completionHandler: nil)
    }
}

