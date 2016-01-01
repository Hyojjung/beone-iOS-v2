
import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(cartItemIds: [Int], order: Order, fetchSuccess: (() -> Void)? = nil) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": cartItemIds], success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
            order.assignObject(data)
            fetchSuccess?()
          }
        }, failure: nil)
    }
  }
}
