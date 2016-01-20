
import UIKit

class ShopList: BaseListModel {
  override func fetchUrl() -> String {
    return "shops"
  }
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let shopList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for shopObject in shopList {
        let shop = Shop()
        shop.assignObject(shopObject)
        list.append(shop)
      }
    }
  }
}
