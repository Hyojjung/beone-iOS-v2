
import UIKit

class Shops: BaseListModel {
  
  lazy var locationId: Int? = {
    return BEONEManager.selectedLocation?.id
  }()
  
  override func getUrl() -> String {
    return "shops"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter[kNetworkRequestKeyLocationId] = locationId
    return parameter
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
