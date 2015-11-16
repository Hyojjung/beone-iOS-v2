
import Foundation
import CoreData

class MyInfo: NSManagedObject {
  
  private static let entityName = "MyInfo"
  
  static func sharedMyInfo() -> MyInfo {
    let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: entityName)
    var result: [AnyObject]?
    do {
      result = try CoreDataHelper.sharedCoreDataHelper.managedObjectContext.executeFetchRequest(fetchRequest)
    } catch _ as NSError{
      result = nil
    }
    
    if let myInfo = result?.first {
      return myInfo as! MyInfo
    } else {
      let myInfo = NSEntityDescription.insertNewObjectForEntityForName(entityName,
        inManagedObjectContext: CoreDataHelper.sharedCoreDataHelper.backgroundContext) as! MyInfo
      CoreDataHelper.sharedCoreDataHelper.saveContext()
      return myInfo
    }
  }
  
  func logOut() {
    accessToken = nil
    refreshToken = nil
    userId = nil
    CoreDataHelper.sharedCoreDataHelper.saveContext()
    SigningHelper.signInForNonUser { (result) -> Void in
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationLogOutSuccess, object: nil)
    }
    // TODO: 실패하면 노답
  }
  
  func isUser() -> Bool {
    return refreshToken != nil
  }
}
