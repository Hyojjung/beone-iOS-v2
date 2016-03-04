
import UIKit

class OrderItemList: BaseListModel {
  
  override func getUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/order-items"
    }
    return "order-items"
  }
  
  override func getParameter() -> AnyObject? {
    return ["isReviewable": true]
  }
  
  override func assignObject(data: AnyObject?) {
    if let orderItemObjects = data as? [[String: AnyObject]] {
      list.removeAll()
      for orderableItemObject in orderItemObjects {
        let orderableItem = OrderableItem()
        orderableItem.assignObject(orderableItemObject)
        list.append(orderableItem)
      }
    }
  }
}
