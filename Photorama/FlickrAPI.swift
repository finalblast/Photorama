//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 2/29/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import Foundation

enum Method: String {
    
    case RecentPhotos = "flickr.photos.getRecent"
    
}

enum PhotosResult {
    
    case Success([Photo])
    case Failure(NSError)
    
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    
    private static let APIKey = "7f3d8cb86a280fd98c621bc3aefd8830"
    
    private static let dateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
        
    }()
    
    private static func flickrURL(#method: Method, parameters: [String: String]?) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
                            "method": method.rawValue,
                            "format": "json",
                            "nojsoncallback": "1",
                            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
            
        }
        
        if let additionalParams = parameters {
            
            for (key, value) in additionalParams {
                
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
                
            }
            
        }
        
        components.queryItems = queryItems
        
        return components.URL!
        
    }
    
    static func recentPhotosURL() -> NSURL {
        
        return flickrURL(method: Method.RecentPhotos, parameters: ["extras": "url_h, date_taken"])
        
    }
    
    static func photosFromJSONData(data: NSData) -> PhotosResult {
        
        var error: NSError?;
        
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
            
            println(jsonObject)
            
            let jsonDic = jsonObject as [NSObject: AnyObject]
            let photos = jsonDic["photos"] as [String: AnyObject]
            let photosArray = photos["photo"] as [[String: AnyObject]]
            var finalPhotos = [Photo]()
            
            for photoJSON in photosArray {
                
                if let photo = photosFromJSONObject(photoJSON) {
                    
                    finalPhotos.append(photo)
                    
                }
                
            }
            
            return PhotosResult.Success(finalPhotos)
            
        } else {
            
            return PhotosResult.Failure(error!)
            
        }
        
    }
    
    static func photosFromJSONObject(json:[String: AnyObject]) -> Photo? {
        
        let photoURLString = json["url_h"] as? String
        
        if let photoURL = photoURLString {
            
            let url = NSURL(string: photoURL)
            let title = json["title"] as String
            let photoID = json["id"] as String
            let dateString = json["datetaken"] as String
            
            let dateTaken = dateFormatter.dateFromString(dateString)
            return Photo(title: title, remoteURL: url!, photoID: photoID, dateTaken: dateTaken!)
            
        }
        
        return nil
        
    }
    
}
