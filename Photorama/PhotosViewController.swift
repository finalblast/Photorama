//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        photoStore.fetchRecentPhotos() {
            
            (photosResult) -> Void in
            
            switch photosResult {
                
            case let PhotosResult.Success(photos):
                println("Found \(photos.count) items")
                
                if let firstPhoto = photos.first {
                    
                    self.photoStore.fetchImageForPhoto(firstPhoto) {
                        
                        (imageResult) -> Void in
                        
                        switch imageResult {
                            
                        case let ImageResult.Success(image):
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                            
                                self.imageView.image = image
                                
                            }
                            
                        case let ImageResult.Failure(_):
                            
                            print("Error!")
                            
                        }
                        
                    }
                    
                }
                
            case let PhotosResult.Failure(error):
                print("Error")
                
            }
            
        }
        
    }
    
}
