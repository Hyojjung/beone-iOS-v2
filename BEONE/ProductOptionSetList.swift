
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
}
