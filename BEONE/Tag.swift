
import UIKit

class Tag: BaseModel, SearchValueProtocol {
  
  var name: String?
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      name = data["name"] as? String
    }
  }
}
