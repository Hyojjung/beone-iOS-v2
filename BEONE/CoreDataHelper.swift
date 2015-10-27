//
//  CoreDataHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject{
  
  private let storeName = "Model"
  private let storeFilename = "Model.sqlite"
  
  lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls.last!
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      preconditionFailure("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  lazy var backgroundContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    backgroundContext.persistentStoreCoordinator = coordinator
    return backgroundContext
    }()
  
  static let sharedCoreDataHelper = CoreDataHelper()
  
  // MARK: - Public Methods
  
  func saveContext(context: NSManagedObjectContext) {
    if context.hasChanges {
      do {
        try context.save()
      } catch let error as NSError {
        preconditionFailure("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  func saveContext() {
    self.saveContext(self.backgroundContext)
  }
}