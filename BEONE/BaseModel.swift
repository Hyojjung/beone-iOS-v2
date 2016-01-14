
import UIKit

let kObjectPropertyKeyId = "id"

class BaseModel: NSObject {
  var id: Int?
  
  // MARK: - Fetch Methods
  
  func fetch() {
    NetworkHelper.requestGet(fetchUrl(), parameter: fetchParameter(), success: fetchSuccess(), failure: fetchFailure())
  }
  
  func get(getSuccess: () -> Void) {
    NetworkHelper.requestGet(fetchUrl(), parameter: fetchParameter(), success: { (result) -> Void in
      self.assignObject(result)
      getSuccess()
      }, failure: nil)
  }
  
  func fetchUrl() -> String {
    fatalError("Must Override")
  }
  
  func fetchParameter() -> AnyObject? {
    return nil
  }
  
  func fetchSuccess() -> NetworkSuccess? {
    return { (result) -> Void in
      self.assignObject(result)
    }
  }
  
  func fetchFailure() -> NetworkFailure? {
    return nil
  }
  
  func assignObject(data: AnyObject) {
    print(data)
  }
  
  // MARK: - Post Methods
  
  func post() {
    NetworkHelper.requestPost(postUrl(), parameter: postParameter(), success: postSuccess(), failure: postFailure())
  }
  
  func postUrl() -> String {
    fatalError("Must Override")
  }
  
  func postParameter() -> AnyObject? {
    return nil
  }
  
  func postSuccess() -> NetworkSuccess? {
    return nil
  }
  
  func postFailure() -> NetworkFailure? {
    return nil
  }
  
  // MARK: - Put Methods
  
  func put() {
    NetworkHelper.requestPut(putUrl(), parameter: putParameter(), success: putSuccess(), failure: putFailure())
  }
  
  func putUrl() -> String {
    fatalError("Must Override")
  }
  
  func putParameter() -> AnyObject? {
    return nil
  }
  
  func putSuccess() -> NetworkSuccess? {
    return nil
  }
  
  func putFailure() -> NetworkFailure? {
    return nil
  }
  
  
  // MARK: - Delete Methods
  
  func delete() {
    NetworkHelper.requestDelete(deleteUrl(), parameter: deleteParameter(), success: deleteSuccess(), failure: deleteFailure())
  }
  
  func deleteUrl() -> String {
    fatalError("Must Override")
  }
  
  func deleteParameter() -> AnyObject? {
    return nil
  }
  
  func deleteSuccess() -> NetworkSuccess? {
    return nil
  }
  
  func deleteFailure() -> NetworkFailure? {
    return nil
  }
}

extension NSObject {
  func postNotification(name: String?, userInfo: [NSObject: AnyObject]? = nil) {
    if let name = name {
      NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: userInfo)
    }
  }
  
  static func postNotification(name: String?, userInfo: [NSObject: AnyObject]? = nil) {
    NSObject().postNotification(name, userInfo: userInfo)
  }
}
