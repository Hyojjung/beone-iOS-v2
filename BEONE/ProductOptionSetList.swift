
import UIKit

class ProductOptionSetList: BaseListModel {
  override func assignObject(data: AnyObject) {
    print(data)
    if let productOptionSetList = data as? [[String: AnyObject]] {
      list.removeAll()
      for productOptionSetObject in productOptionSetList {
        let productOptionSet = ProductOptionSet()
        productOptionSet.assignObject(productOptionSetObject)
        list.append(productOptionSet)
      }
    }
  }
}
