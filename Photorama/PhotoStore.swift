//
//  PhotoStore.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

enum ImageResult {
    
    case Success(UIImage)
    case Failure(NSError)
    
}

class PhotoStore {
    
    let session: NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
    }()
    
    func fetchRecentPhotos(#completion: (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let result = self.processRecentPhotosRequest(data: data)
            completion(result)
            
        }
        
        task.resume()
        
    }
    
    func processRecentPhotosRequest(#data: NSData?) -> PhotosResult {
        
        if let jsonData = data {
            
            return FlickrAPI.photosFromJSONData(jsonData)
            
        } else {
            
            return PhotosResult.Failure(NSError(domain: "test", code: 0, userInfo: nil))
            
        }
        
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        let task = session.dataTaskWithRequest(request) {
            
            (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse
            
            if let responseData = httpResponse {
                
                println("Status Code: \(responseData.statusCode)")
                println("Header Fields: \(responseData.allHeaderFields)")
                
            }
            
            let result = self.processImageRequest(data: data)
            
            switch result {
                
            case let ImageResult.Success(image):
                photo.image = image
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
    
}
