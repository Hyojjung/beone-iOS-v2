
import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(cartItemIds: [Int], order: Order, fetchSuccess: () -> Void) {
    order.cartItemIds = cartItemIds
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": cartItemIds], success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
            order.assignObject(data)
            fetchSuccess()
          }
        }, failure: nil)
    }
  }
  
  static func fetchPaymentTypeList(fetchSuccess: (paymentTypes: [PaymentType]) -> Void) {
    NetworkHelper.requestGet("payment-types", parameter: nil, success: { (result) -> Void in
      var paymentTypes = [PaymentType]()
      if let paymentTypeObjects = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
        for paymentTypeObject in paymentTypeObjects {
          let paymentType = PaymentType()
          paymentType.assignObject(paymentTypeObject)
          paymentTypes.append(paymentType)
        }
        fetchSuccess(paymentTypes: paymentTypes)
      }
      }, failure: nil)
  }
}
