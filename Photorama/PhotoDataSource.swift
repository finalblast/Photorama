//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 3/1/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as PhotoCollectionViewCell
       
        let photo = photos[indexPath.row]
        cell.updateWithPhoto(photo)
        
        return cell
        
    }
    
}
