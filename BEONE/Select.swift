
import UIKit

class Select: BaseModel {
  var name: String?
  var isSoldOut = false
  var price = 0
  
  override func assignObject(data: AnyObject?) {
    if let selectObject = data as? [String: AnyObject] {
      if let originalId = selectObject["originalId"] as? Int {
        id = originalId
      } else {
        id = selectObject[kObjectPropertyKeyId] as? Int
      }
      name = selectObject[kObjectPropertyKeyName] as? String
      if let isSoldOut = selectObject["isSoldOut"] as? Bool {
        self.isSoldOut = isSoldOut
      }
      if let actualPrice = selectObject["actualPrice"] as? Int {
        price = actualPrice
      }
    }
  }
  
  override func copy() -> AnyObject {
    let select = Select()
    select.id = id
    select.name = name?.copy() as? String
    select.price = price
    select.isSoldOut = isSoldOut
    return select
  }
  
  func selectName() -> String? {
    if price == 0 {
      return name
    } else if let name = name {
      return name + " (+ \(price.priceNotation(.Korean)))"
    }
    return nil
  }
}
