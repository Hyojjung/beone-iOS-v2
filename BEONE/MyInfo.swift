
import Foundation
import CoreData

let kMyInfoPropertyKeyEmail = "email"
let kMyInfoPropertyKeyPoint = "point"
let kMyInfoPropertyKeyPhone = "phone"
let kMyInfoPropertyKeyAccount = "account"

enum Gender: String {
  case Male = "male"
  case Female = "female"
}

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
      self.account = myInfo[kMyInfoPropertyKeyAccount] as? String
      self.email = myInfo[kMyInfoPropertyKeyEmail] as? String
      self.name = myInfo[kObjectPropertyKeyName] as? String
      self.phone = myInfo[kMyInfoPropertyKeyPhone] as? String
      self.gender = myInfo["gender"] as? String
      self.point = myInfo[kMyInfoPropertyKeyPoint] as? NSNumber
      if let birthday = myInfo["birthday"] as? String {
        self.birthday = birthday.date()
      } else {
        self.birthday = nil
      }
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  func put(putSuccess: () -> Void) {
    if let userId = userId {
      var parameter = [String: AnyObject]()
      parameter[kMyInfoPropertyKeyEmail] = email
      parameter[kObjectPropertyKeyName] = name
      parameter[kMyInfoPropertyKeyPhone] = phone
      parameter["gender"] = gender
      
      if let birthday = birthday {
        
        let calendar = DateFormatterHelper.koreanCalendar
        let components = calendar.components([.Year, .Month, .Day], fromDate: birthday)
        let day = "\(components.year)-\(components.month)-\(components.day)"
        let serverDayFormatter = NSDateFormatter()
        serverDayFormatter.dateFormat = "yyyy-M-dd"
        self.birthday = serverDayFormatter.dateFromString(day)
        self.birthday = self.birthday?.dateByAddingTimeInterval(NSTimeInterval(NSTimeZone.localTimeZone().secondsFromGMT))
        
        parameter["birthday"] = self.birthday?.serverDateString()
      }

      NetworkHelper.requestPut("users/\(userId)", parameter: parameter, success: { (result) -> Void in
        putSuccess()
        }, failure: nil)
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

extension MyInfo {
  func changePassword(password: String, newPassword: String, success: () -> Void, failure: (NetworkError) -> Void) {
    let parameter = ["password": password, "newPassword": newPassword]
    NetworkHelper.requestPut("users/\(MyInfo.sharedMyInfo().userId!)/password",
                              parameter: parameter,
                              success: { (result) in
                                success()
    }) { (error) in
      failure(error)
    }
  }
}
