
import UIKit

class SideBarViewContents: BaseModel {
  
  var progressingOrderCount = 0
  var userAnniversariesCount = 0
  var orderDeliveryItemSets = [OrderableItemSet]()
  var recentProducts = Products()
  var anniversary: Anniversary?
  
  override func getUrl() -> String {
    return "app-view-data/sidebar"
  }
  
  override func assignObject(data: AnyObject?) {
    print(data)
    if let sideBarViewContents = data as? [String: AnyObject] {
      if let user = sideBarViewContents["user"] as? [String: AnyObject] {
        MyInfo.sharedMyInfo().assignObject(user)
        anniversary = nil
        if let userAnniversaries = user["userAnniversaries"] as? [[String: AnyObject]] {
          if !userAnniversaries.isEmpty {
            anniversary = Anniversary()
            anniversary?.assignObject(userAnniversaries.first)
          }
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
        orderDeliveryItemSets.appendObject(latestOrderDeliveryItemSet)
      }
      
      recentProducts.assignObject(sideBarViewContents["recentProducts"])
    }
  }
}
