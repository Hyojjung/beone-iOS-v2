
import UIKit

class SideBarViewContents: BaseModel {
  
  var progressingOrderCount = 0
  var orderDeliveryItemSets = [OrderableItemSet]()
  
  override func fetchUrl() -> String {
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
      
      if let orderDeliveryItemSet = data["latestOrderDeliveryItemSet"] as? [String: AnyObject] {
        orderDeliveryItemSets.removeAll()
        let latestOrderDeliveryItemSet = OrderableItemSet()
        latestOrderDeliveryItemSet.assignObject(orderDeliveryItemSet)
        orderDeliveryItemSets.append(latestOrderDeliveryItemSet)
      }
    }
  }
}
