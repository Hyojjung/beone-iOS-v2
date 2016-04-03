
import UIKit

class ShopList: BaseListModel {
  
  lazy var locationId: Int? = {
    return BEONEManager.selectedLocation?.id
  }()
  
  override func getUrl() -> String {
    return "shops"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["locationId"] = locationId
    return parameter
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
