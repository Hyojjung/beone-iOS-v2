
import UIKit

class ProductOptionSet: BaseModel {
  var name: String?
  var options = [Option]()
  
  override func assignObject(data: AnyObject) {
    if let productOptionSetObject = data as? [String: AnyObject] {
      id = productOptionSetObject[kObjectPropertyKeyId] as? Int
      name = productOptionSetObject["name"] as? String
      if let optionObjects = productOptionSetObject["options"] as? [[String: AnyObject]] {
        options.removeAll()
        for optionObject in optionObjects {
          let option = Option()
          option.assignObject(optionObject)
          options.append(option)
        }
      }
    }
  }
}
