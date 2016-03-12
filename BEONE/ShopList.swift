
import UIKit

class ShopList: BaseListModel {
  override func getUrl() -> String {
    return "shops"
  }
  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let shopList = data as? [[String: AnyObject]] {
      for shopObject in shopList {
        let shop = Shop()
        shop.assignObject(shopObject)
        list.appendObject(shop)
      }
    }
  }
}
