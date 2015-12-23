
import UIKit

class Select: BaseModel {
  var name: String?
  var isSoldOut = false
  var price = 0
  
  override func assignObject(data: AnyObject) {
    if let selectObject = data as? [String: AnyObject] {
      id = selectObject[kObjectPropertyKeyId] as? Int
      name = selectObject["name"] as? String
      if let isSoldOut = selectObject["isSoldOut"] as? Bool {
        self.isSoldOut = isSoldOut
      }
      if let actualPrice = selectObject["actualPrice"] as? Int {
        price = actualPrice
      }
    }
  }
}
