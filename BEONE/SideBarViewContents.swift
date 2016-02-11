
import UIKit

class SideBarViewContents: BaseModel {
  
  var progressingOrderCount = 0
  var orderDeliveryItemSets = [OrderableItemSet]()
  var recentProducts = ProductList()
  
  override func getUrl() -> String {
    return "app-view-data/sidebar"
  }
  
  override func assignObject(data: AnyObject) {
    print(data)
    if let data = data as? [String: AnyObject] {
      if let user = data["user"] as? [String: AnyObject] {
        MyInfo.sharedMyInfo().assignObject(user)
      }
      
      if let progressingOrderCount = data["progressingOrderCount"] as? Int {
        self.progressingOrderCount = progressingOrderCount
      }
      
      orderDeliveryItemSets.removeAll()
      if let orderDeliveryItemSet = data["latestOrderDeliveryItemSet"] as? [String: AnyObject] {
        let latestOrderDeliveryItemSet = OrderableItemSet()
        latestOrderDeliveryItemSet.assignObject(orderDeliveryItemSet)
        orderDeliveryItemSets.append(latestOrderDeliveryItemSet)
      }
      
      if let recentProducts = data["recentProducts"] {
        self.recentProducts.assignObject(recentProducts)
      } else {
        recentProducts.list.removeAll()
      }
    }
  }
}
