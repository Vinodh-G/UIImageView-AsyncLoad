//
//  ImagesCollectionViewController.swift
//  DownloadImagesSample
//
//  Created by Vinodh Swamy on 12/1/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCellId"

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var dataManager = DataManager.shared
    let transitionDelegate: CollectionViewTransitioningDelegate = CollectionViewTransitioningDelegate()
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TumbnailCell
    

        configureCell(cell: cell, forPhoto: dataManager.photoAt(index: indexPath.row)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        var cellSize = view.bounds.size
        cellSize.width = (view.bounds.size.width - 6) / 3
        cellSize.height = view.bounds.size.height / 6
        return cellSize
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let attributes = collectionView.layoutAttributesForItem(at: indexPath as IndexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to:  collectionView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let imageViewController : ImageViewController = storyBoard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageViewController.photo = dataManager.photoAt(index: indexPath.row)!
        imageViewController.modalPresentationStyle = .custom
        imageViewController.transitioningDelegate = transitionDelegate
        present(imageViewController,
                animated: true,
                completion: nil)
    }
    
    func configureCell(cell : TumbnailCell, forPhoto:Photo){
        
        cell.imageContentView.setImageFrom(imageURLString: forPhoto.tumbnailUrl, placeHolderImage: UIImage(named:"placeHolerImage"), completionHandler: nil)
    }
}

