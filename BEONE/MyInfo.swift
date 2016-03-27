
import Foundation
import CoreData

let kMyInfoPropertyKeyEmail = "email"
let kMyInfoPropertyKeyPoint = "point"
let kMyInfoPropertyKeyPhone = "phone"

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
  
  func get(getSuccess: (() -> Void)? = nil) {
    if let userId = userId {
      NetworkHelper.requestGet("users/\(userId)", parameter: nil, success: { (result) -> Void in
        self.assignObject(result[kNetworkResponseKeyData])
        getSuccess?()
        }, failure: nil)
    }
  }
  
  func assignObject(data: AnyObject?) {
    if let myInfo = data as? [String: AnyObject] {
      self.email = myInfo[kMyInfoPropertyKeyEmail] as? String
      self.name = myInfo[kObjectPropertyKeyName] as? String
      self.phone = myInfo[kMyInfoPropertyKeyPhone] as? String
      self.point = myInfo[kMyInfoPropertyKeyPoint] as? NSNumber
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  func logOut(logoutSuccess: () -> Void) {
    SigningHelper.signInForNonUser { (result) -> Void in
      self.refreshToken = nil
      self.userId = nil
      CoreDataHelper.sharedCoreDataHelper.saveContext()
      logoutSuccess()
    }
  }
  
  func isUser() -> Bool {
    return refreshToken != nil
  }
}
