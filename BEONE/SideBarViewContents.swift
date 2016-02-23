
import UIKit

class SideBarViewContents: BaseModel {
  
  var progressingOrderCount = 0
  var userAnniversariesCount = 0
  var orderDeliveryItemSets = [OrderableItemSet]()
  var recentProducts = ProductList()
  var anniversary: Anniversary?
  
  override func getUrl() -> String {
    return "app-view-data/sidebar"
  }
  
  override func assignObject(data: AnyObject?) {
    if let sideBarViewContents = data as? [String: AnyObject] {
      if let user = sideBarViewContents["user"] as? [String: AnyObject] {
        MyInfo.sharedMyInfo().assignObject(user)
        if let userAnniversaries = user["userAnniversaries"] as? [[String: AnyObject]] {
          anniversary = Anniversary()
          anniversary?.assignObject(userAnniversaries.first)
        } else {
          anniversary = nil
        }
      }
      
      if let userAnniversariesCount = sideBarViewContents["userAnniversariesCount"] as? Int {
        self.userAnniversariesCount = userAnniversariesCount
      }
      if let progressingOrderCount = sideBarViewContents["progressingOrderCount"] as? Int {
        self.progressingOrderCount = progressingOrderCount
      }
      
      orderDeliveryItemSets.removeAll()
      if let orderDeliveryItemSet = sideBarViewContents["latestOrderDeliveryItemSet"] as? [String: AnyObject] {
        let latestOrderDeliveryItemSet = OrderableItemSet()
        latestOrderDeliveryItemSet.assignObject(orderDeliveryItemSet)
        orderDeliveryItemSets.append(latestOrderDeliveryItemSet)
      }
      
      recentProducts.assignObject(sideBarViewContents["recentProducts"])
    }
  }
}
