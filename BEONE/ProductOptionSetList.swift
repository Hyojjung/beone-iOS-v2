
import UIKit

class ProductOptionSetList: BaseListModel {
  override func assignObject(data: AnyObject?) {
    if let productOptionSetList = data as? [[String: AnyObject]] {
      list.removeAll()
      for productOptionSetObject in productOptionSetList {
        let productOptionSet = ProductOptionSet()
        productOptionSet.assignObject(productOptionSetObject)
        list.appendObject(productOptionSet)
      }
    }
  }
  
  override func copy() -> AnyObject {
    let productOptionSetList = ProductOptionSetList()
    for productOptionSet in list {
      let copiedProductOptionSet = productOptionSet.copy()
      productOptionSetList.list.appendObject(copiedProductOptionSet as! BaseModel)
    }
    return productOptionSetList
  }
  
  func validationMessage() -> String? {
    for productOptionSet in list as! [ProductOptionSet] {
      if let validationMessage = productOptionSet.validationMessage() {
        return validationMessage
      }
    }
    return nil
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
      serverFormat.appendObject(productOptionSet.serverFormat())
    }
    return serverFormat
  }
}
