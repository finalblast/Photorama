//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 3/1/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        
        didSet {
            
            navigationItem.title = photo.title
            
        }
        
    }
    
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        store.fetchImageForPhoto(photo) {
            
            (result) -> Void in
            
            switch result {
                
                case let ImageResult.Success(image):
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        
                        self.imageView.image = image
                        
                }
                
                let viewCount = self.photo.numberOfViews
                self.photo.numberOfViews = NSNumber(integer: viewCount.integerValue + 1)
                    
                self.store.coreDataStack.saveChanges()
                
            case let ImageResult.Failure(_):
                break
                
            }
            
        }
        
    }
    
}
