
import UIKit

class SnsInfo: BaseModel {
  var type: SnsType = .Facebook
  var uid: String?
  var snsToken: String?
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      if let typeString = data["snsType"] as? String, type = SnsType(rawValue: typeString) {
        self.type = type
      }
    }
  }
  
  override func postUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/sns-infos"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["snsType"] = type.rawValue
    parameter["uid"] = uid
    parameter["snsToken"] = snsToken
    return parameter
  }
  
  override func deleteUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/sns-infos/\(id!)"
  }
}
