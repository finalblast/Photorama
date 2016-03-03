//
//  PhotoStore.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    
    case Success(UIImage)
    case Failure(NSError)
    
}

class PhotoStore {
    
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    let imageStore = ImageStore()
    
    let session: NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
    }()
    
    func fetchRecentPhotos(#completion: (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            var result = self.processRecentPhotosRequest(data: data)
            switch(result) {
                
            case let PhotosResult.Success(photos):
                
                let mainQueueContext = self.coreDataStack.mainQueueContext
                mainQueueContext.obtainPermanentIDsForObjects(photos, error: nil)
                let objectIDs = photos.map{ $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
                
                self.coreDataStack.saveChanges()
                let mainQueuePhotos = self.fetchMainQueuePhotos(predicate: predicate, sortDescriptors: [sortByDateTaken])
                result = PhotosResult.Success(mainQueuePhotos)
                
            case let PhotosResult.Failure(_):
                break
                
            }
            
            completion(result)
            
        }
        
        task.resume()
        
    }
    
    func processRecentPhotosRequest(#data: NSData?) -> PhotosResult {
        
        if let jsonData = data {
            
            return FlickrAPI.photosFromJSONData(jsonData, inContext: self.coreDataStack.mainQueueContext)
            
        } else {
            
            return PhotosResult.Failure(NSError(domain: "test", code: 0, userInfo: nil))
            
        }
        
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        
        let photoKey = photo.photoKey
        if let image = imageStore.imageForKey(photoKey) {
            
            photo.image = image
            completion(ImageResult.Success(image))
            return
            
        }
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        let task = session.dataTaskWithRequest(request) {
            
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data)
            
            switch result {
                
            case let ImageResult.Success(image):
                photo.image = image
                self.imageStore.setImage(image, forKey: photo.photoKey)
            case ImageResult.Failure(_):
                break
            default:
                break
                
            }
            
            completion(result)
            
        }
        
        task.resume()
        
    }
    
    func processImageRequest(#data: NSData?) -> ImageResult {
        
        if let image = UIImage(data: data!) {
            
            return ImageResult.Success(image)
            
        } else {
            
            return ImageResult.Failure(NSError(domain: "test", code: 0, userInfo: nil))
            
        }
        
    }
    
    func fetchMainQueuePhotos(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Photo] {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueue = self.coreDataStack.mainQueueContext
        var mainQueuePhotos: [Photo]?
        mainQueue.performBlockAndWait() {
            
            mainQueuePhotos = mainQueue.executeFetchRequest(fetchRequest, error: nil) as? [Photo]
            
        }
       
        return mainQueuePhotos!
        
    }
    
}
