
import UIKit

class ProductPropertyList: BaseListModel {
  
  var forQuickSearch: Bool?
  var forSearch: Bool?
  
  override func getUrl() -> String {
    return "product-properties"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["forQuickSearch"] = forQuickSearch
    parameter["forSearch"] = forSearch
    return parameter
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