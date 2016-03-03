//
//  Photo.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 3/2/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

class Photo: NSManagedObject {
 
    var image: UIImage?
    @NSManaged var dateTaken: NSDate
    @NSManaged var photoID: String
    @NSManaged var photoKey: String
    @NSManaged var remoteURL: NSURL
    @NSManaged var title: String
    @NSManaged var numberOfViews: NSNumber

    override func awakeFromInsert() {
        
        super.awakeFromInsert()
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
        numberOfViews = 0
        
    }
    
}
