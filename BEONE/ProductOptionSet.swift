
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
  
  override func copy() -> AnyObject {
    let productOptionSet = ProductOptionSet()
    productOptionSet.id = id
    productOptionSet.name = name?.copy() as? String
    for option in options {
      let copiedOption = option.copy()
      productOptionSet.options.append(copiedOption as! Option)
    }
    return productOptionSet
  }
  
  func isValid() -> Bool {
    for option in options {
      if option.isSelected && !option.isValid() {
        return false
      }
    }
    return true
  }
  
  func optionString() -> String {
    var optionString = String()
    for option in options {
      if option.isSelected {
        optionString += "\(option.optionString())"
      }
    }
    return optionString
  }
  
  func serverFormat() -> [String: AnyObject] {
    var serverFormat = [String: AnyObject]()
    serverFormat["originalId"] = id
    if options.count > 0 {
      var optionsServerFormat = [[String: AnyObject]]()
      for option in options {
        optionsServerFormat.append(option.serverFormat())
      }
      serverFormat["options"] = optionsServerFormat
    }
    return serverFormat
  }
}
