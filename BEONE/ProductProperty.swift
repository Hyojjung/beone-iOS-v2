
import UIKit

let kPartialValuesCount = 8

enum ProductPropertyDisplayType: String {
  case Name = "name"
  case Color = "color"
}

class ProductProperty: BaseModel {
  var name: String?
  var displayType: ProductPropertyDisplayType?
  var values = [ProductPropertyValue]()
  var desc: String?
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      desc = data[kObjectPropertyKeyDescription] as? String
      name = data[kObjectPropertyKeyName] as? String
      if let displayType = data["displayType"] as? String {
        self.displayType = ProductPropertyDisplayType(rawValue: displayType)
      }
      
      if let values = data["values"] as? [[String: AnyObject]] {
        self.values.removeAll()
        for value in values {
          let productPropertyValue = ProductPropertyValue()
          productPropertyValue.assignObject(value)
          self.values.appendObject(productPropertyValue)
        }
      }
    }
  }
  
  func productPropertyWithPartValues() -> ProductProperty {
    let productProperty = ProductProperty()
    productProperty.name = name
    productProperty.desc = desc
    productProperty.id = id
    for (index, productPropertyValue) in values.enumerate() {
      if index < kPartialValuesCount {
        productProperty.values.appendObject(productPropertyValue)
      }
    }
    return productProperty
  }
  
  func valueTitles() -> [String] {
    var valueTitles = [String]()
    for value in values {
      valueTitles.appendObject(value.name!)
    }
    return valueTitles
  }
}
