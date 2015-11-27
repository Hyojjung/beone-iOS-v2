
import Foundation
import CoreData

let kMyInfoPropertyKeyEmail = "email"
let kMyInfoPropertyKeyName = "name"
let kMyInfoPropertyKeyPoint = "point"

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
  
  func fetch() {
    if let userId = userId {
      NetworkHelper.requestGet("users/\(userId)", parameter: nil, success: { (result) -> Void in
        if let myInfo = result[kNetworkResponseKeyData] as? [String: AnyObject] {
          self.email = myInfo[kMyInfoPropertyKeyEmail] as? String
          self.name = myInfo[kMyInfoPropertyKeyName] as? String
          self.point = myInfo[kMyInfoPropertyKeyName] as? NSNumber
          CoreDataHelper.sharedCoreDataHelper.saveContext()
          self.postNotification(kNotificationFetchMyInfoSuccess)
        }
        }, failure: nil)
    }
  }
  
  func logOut() {
    accessToken = nil
    refreshToken = nil
    userId = nil
    CoreDataHelper.sharedCoreDataHelper.saveContext()
    SigningHelper.signInForNonUser { (result) -> Void in
      self.postNotification(kNotificationLogOutSuccess)
    }
    // TODO: 실패하면 노답
  }
  
  func isUser() -> Bool {
    return refreshToken != nil
  }
}
