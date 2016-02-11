
import UIKit

class ProductPropertyList: BaseListModel {
  override func getUrl() -> String {
    return "product-properties"
  }
  
  override func assignObject(data: AnyObject) {
    if let productPropertyObjects = data as? [[String: AnyObject]] {
      list.removeAll()
      for productPropertyObject in productPropertyObjects {
        let productProperty = ProductProperty()
        productProperty.assignObject(productPropertyObject)
        list.append(productProperty)
      }
    }
  }
}