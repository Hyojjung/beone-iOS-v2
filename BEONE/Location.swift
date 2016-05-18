
import UIKit

private let kLocationValidationPropertyKeyIsValid = "isValid"

class Location: BaseModel {
  
  var name: String?
  
  override func assignObject(data: AnyObject?) {
    if let location = data as? [String: AnyObject] {
      id = location[kObjectPropertyKeyId] as? Int
      name = location[kObjectPropertyKeyName] as? String
    }
  }
}
