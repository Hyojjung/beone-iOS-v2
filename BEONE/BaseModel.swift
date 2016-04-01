
import UIKit

let kObjectPropertyKeyId = "id"
let kObjectPropertyKeyName = "name"
let kObjectPropertyKeyDescription = "description"

class BaseModel: NSObject {
  var id: Int?
  
  // MARK: - Fetch Methods
  
  func get(getSuccess: (() -> Void)? = nil) {
    NetworkHelper.requestGet(getUrl(), parameter: getParameter(), success: { (result) -> Void in
      self.assignObject(result[kNetworkResponseKeyData])
      getSuccess?()
      }, failure: nil)
  }
  
  func getUrl() -> String {
    fatalError("Must Override")
  }
  
  func getParameter() -> AnyObject? {
    return nil
  }
  
  func getSuccess() -> NetworkSuccess? {
    return { (result) -> Void in
      self.assignObject(result)
    }
  }
  
  func getFailure() -> NetworkFailure? {
    return nil
  }
  
  func assignObject(data: AnyObject?) {
    print(data)
  }
  
  // MARK: - Post Methods
  
  func post(postSuccess: ((AnyObject?) -> Void)? = nil, postFailure: ((NetworkError) -> Void)? = nil) {
    NetworkHelper.requestPost(postUrl(), parameter: postParameter(), success: { (result) -> Void in
      postSuccess?(result)
      }, failure: {(error) -> Void in
        postFailure?(error)
    })
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
  
  func put(putSuccess: ((AnyObject?) -> Void)? = nil, putFailure: ((NetworkError) -> Void)? = nil) {
    NetworkHelper.requestPut(putUrl(), parameter: putParameter(), success: { (result) -> Void in
      putSuccess?(result)
      }) { (error) -> Void in
        putFailure?(error)
    }
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
  
  func remove(deleteSuccess: (() -> Void)? = nil, deleteFailure: ((NetworkError) -> Void)? = nil) {
    NetworkHelper.requestDelete(deleteUrl(), parameter: deleteParameter(), success: { (result) -> Void in
      deleteSuccess?()
      }, failure: { (error) in
      deleteFailure?(error)
    })
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
