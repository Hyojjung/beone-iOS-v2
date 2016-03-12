
import UIKit

class OrderList: BaseListModel {

  override func getUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/orders"
    }
    return "orders"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["orderListType"] = "visible"
    return parameter
  }
  
  override func assignObject(data: AnyObject?) {
    if let orders = data as? [[String: AnyObject]] {
      list.removeAll()
      for orderObject in orders {
        let order = Order()
        order.assignObject(orderObject)
        list.appendObject(order)
      }
    }
  }
}
