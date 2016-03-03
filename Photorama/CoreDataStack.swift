//
//  CoreDataStack.swift
//  Photorama
//
//  Created by Nam (Nick) N. HUYNH on 3/2/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
       let modelURL = NSBundle.mainBundle().URLForResource(self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
    }()
    
    private var applicationDocumentDirectory: NSURL = {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls.first! as NSURL
        
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
       var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentDirectory.URLByAppendingPathComponent(pathComponent)
        let store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: nil)
        return coordinator
        
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
       let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        return moc
        
    }()
    
    required init(modelName: String) {
        
        managedObjectModelName = modelName
        
    }
    
    func saveChanges() {
    
        mainQueueContext.performBlockAndWait() {
            
            if self.mainQueueContext.hasChanges {
                
                self.mainQueueContext.save(nil)
                
            }
            
        }
    
    }
    
}
