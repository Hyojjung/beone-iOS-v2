
import UIKit

let kObjectPropertyKeyId = "id"

class BaseModel: NSObject {
  var id: NSNumber?
  
  func assignObject(data: AnyObject) {
    fatalError("Must Override")
  }
  
  func post() {
    NetworkHelper.request(NetworkMethod.Post,
      url: postUrl(),
      parameter: postParameter(),
      success: postSuccess(),
      failure: postFailure())
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
  
  func fetch() {
    NetworkHelper.request(NetworkMethod.Get,
      url: fetchUrl(),
      parameter: fetchParameter(),
      success: fetchSuccess(),
      failure: fetchFailure())
  }
  
  func fetchUrl() -> String {
    fatalError("Must Override")
  }
  
  func fetchParameter() -> AnyObject? {
    return nil
  }
  
  func fetchSuccess() -> NetworkSuccess? {
    return { (result) -> Void in
      if let result = result {
        self.assignObject(result)
      }
    }
  }
  
  func fetchFailure() -> NetworkFailure? {
    return nil
  }
  
  func put() {
    NetworkHelper.request(NetworkMethod.Put,
      url: putUrl(),
      parameter: putParameter(),
      success: putSuccess(),
      failure: putFailure())
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
  
  func delete() {
    NetworkHelper.request(NetworkMethod.Delete,
      url: deleteUrl(),
      parameter: deleteParameter(),
      success: deleteSuccess(),
      failure: deleteFailure())
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
