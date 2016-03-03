//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//z

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photoStore: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewWillAppear(animated: Bool) {
        
        collectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        photoStore.fetchRecentPhotos() {
            
            (photosResult) -> Void in
            
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = self.photoStore.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDateTaken])
            println("Found \(allPhotos.count)")
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0))
                
            }
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        photoStore.fetchImageForPhoto(photo) {
            
            (result) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                
                let photoIndex = find(self.photoDataSource.photos, photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                if let cell = collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell {
                    
                    cell.updateWithPhoto(photo)
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: Preparing for segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowPhoto" {
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first as? NSIndexPath {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destinationViewController as PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = photoStore
                
            }
            
        }
        
    }
    
    // MARK: Will Rotate - Change CollectionView Layout
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    // MARK: Flow layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let cellWidth = screenWidth/5
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
}
