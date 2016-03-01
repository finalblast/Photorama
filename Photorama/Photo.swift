//
//  Photo.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class Photo: Equatable {
    
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, remoteURL: NSURL, photoID: String, dateTaken: NSDate) {
        
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
        
    }
    
}

func ==(lhs: Photo, rhs: Photo) -> Bool {
    
    return lhs.photoID == rhs.photoID
    
}


