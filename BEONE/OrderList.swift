
import UIKit

class OrderList: BaseListModel {

  override func fetchUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/orders"
    }
    return "orders"
  }
  
  override func assignObject(data: AnyObject) {
    if let orders = data as? [[String: AnyObject]] {
      list.removeAll()
      for orderObject in orders {
        let order = Order()
        order.assignObject(orderObject)
        list.append(order)
      }
    }
  }
}
