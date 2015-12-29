
import UIKit

class ProductOptionSetList: BaseListModel {
  override func assignObject(data: AnyObject) {
    if let productOptionSetList = data as? [[String: AnyObject]] {
      list.removeAll()
      for productOptionSetObject in productOptionSetList {
        let productOptionSet = ProductOptionSet()
        productOptionSet.assignObject(productOptionSetObject)
        list.append(productOptionSet)
      }
    }
  }
  
  override func copy() -> AnyObject {
    let productOptionSetList = ProductOptionSetList()
    for productOptionSet in list {
      let copiedProductOptionSet = productOptionSet.copy()
      productOptionSetList.list.append(copiedProductOptionSet as! BaseModel)
    }
    return productOptionSetList
  }
  
  func isValid() -> Bool {
    for productOptionSet in list as! [ProductOptionSet] {
      if !productOptionSet.isValid() {
        return false
      }
    }
    return true
  }
  
  func optionString() -> String {
    var optionString = String()
    for (index, productOptionSet) in (list as! [ProductOptionSet]).enumerate() {
      optionString += productOptionSet.optionString()
      if index != list.count - 1 {
        optionString += "\n"
      }
    }
    return optionString
  }
  
  func serverFormat() -> [[String: AnyObject]] {
    var serverFormat = [[String: AnyObject]]()
    for productOptionSet in list as! [ProductOptionSet] {
      serverFormat.append(productOptionSet.serverFormat())
    }
    return serverFormat
  }
}
