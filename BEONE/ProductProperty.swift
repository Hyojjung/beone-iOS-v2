
import UIKit

let kPartialValuesCount = 8

enum ProductPropertyDisplayType: String {
  case Name = "name"
  case Color = "color"
}

class ProductProperty: BaseModel {
  var name: String?
  var alias: String?
  var displayType: ProductPropertyDisplayType?
  var values = [ProductPropertyValue]()
  var subTitle: String?
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      subTitle = data["description"] as? String
      name = data["name"] as? String
      alias = data["alias"] as? String
      if let displayType = data["displayType"] as? String {
        self.displayType = ProductPropertyDisplayType(rawValue: displayType)
      }
      
      if let values = data["values"] as? [[String: AnyObject]] {
        self.values.removeAll()
        for value in values {
          let productPropertyValue = ProductPropertyValue()
          productPropertyValue.assignObject(value)
          self.values.append(productPropertyValue)
        }
      }
    }
  }
  
  func productPropertyWithPartValues() -> ProductProperty {
    let productProperty = ProductProperty()
    productProperty.name = name
    productProperty.subTitle = subTitle
    productProperty.id = id
    for (index, productPropertyValue) in values.enumerate() {
      if index < kPartialValuesCount {
        productProperty.values.append(productPropertyValue)
      }
    }
    return productProperty
  }
}