
import UIKit

class SideBarViewContents: BaseModel {
  
  var proceedingOrderCount = 0
  var latestOrderDeliveryItemSet = OrderableItemSet()
  
  override func fetchUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/sidebar"
    } else {
      return "users"
    }
  }
  
  override func assignObject(data: AnyObject) {
    print(data)
    if let data = data as? [String: AnyObject] {
      if let user = data["user"] as? [String: AnyObject] {
        MyInfo.sharedMyInfo().email = user["email"] as? String
        MyInfo.sharedMyInfo().point = user["point"] as? Int
        CoreDataHelper.sharedCoreDataHelper.saveContext()
      }
      
      if let proceedingOrderCount = data["proceedingOrderCount"] as? Int {
        self.proceedingOrderCount = proceedingOrderCount
      }
      
      if let latestOrderDeliveryItemSet = data["latestOrderDeliveryItemSet"] as? [String: AnyObject] {
        self.latestOrderDeliveryItemSet.assignObject(latestOrderDeliveryItemSet)
      }
    }
  }
}
