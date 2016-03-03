//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 3/1/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var numberOfViews: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var viewCount: Int! {
        
        didSet {
            
            numberOfViews.text = "\(viewCount)"
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        updateWithImage(nil)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        updateWithImage(nil)
        
    }

    func updateWithPhoto(photo: Photo?) {
        
        if let currentPhoto = photo {
            
            updateWithImage(currentPhoto.image)
            viewCount = currentPhoto.numberOfViews.integerValue
            
        } else {
            
            updateWithImage(nil)
            
        }
        
    }
    
    func updateWithImage(image: UIImage?) {
        
        if let imageToDisplay = image {
            
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
        
    }
    
}
