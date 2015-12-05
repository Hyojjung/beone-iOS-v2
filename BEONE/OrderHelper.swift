
import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(cartItemIds: [Int]) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": cartItemIds], success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
            BEONEManager.selectedOrder.assignObject(data)
          }
        }, failure: nil)
    }
  }
}
