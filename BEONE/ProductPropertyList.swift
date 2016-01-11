
import UIKit

class ProductPropertyList: BaseListModel {
  override func fetchUrl() -> String {
    return "product-properties"
  }
  
  override func assignObject(data: AnyObject) {
    if let productPropertyObjects = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      for productPropertyObject in productPropertyObjects {
        let productProperty = ProductProperty()
        productProperty.assignObject(productPropertyObject)
        list.append(productProperty)
      }
    }
  }
}