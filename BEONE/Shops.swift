
import UIKit

class Shops: BaseListModel {
  
  override func getUrl() -> String {
    return "shops"
  }

  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let shops = data as? [[String: AnyObject]] {
      for shopObject in shops {
        let shop = Shop()
        shop.assignObject(shopObject)
        list.appendObject(shop)
      }
    }
  }
}
