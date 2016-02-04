
import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(order: Order, fetchSuccess: () -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": order.cartItemIds], success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
            order.assignObject(data)
            fetchSuccess()
          }
        }, failure: nil)
    }
  }
  
  static func fetchPaymentTypeList(fetchSuccess: (paymentTypeList: PaymentTypeList) -> Void) {
    NetworkHelper.requestGet("payment-types", parameter: ["isAvailable": true], success: { (result) -> Void in
      let paymentTypeList = PaymentTypeList()
      if let paymentTypeObjects = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
        for paymentTypeObject in paymentTypeObjects {
          let paymentType = PaymentType()
          paymentType.assignObject(paymentTypeObject)
          paymentTypeList.list.append(paymentType)
        }
        fetchSuccess(paymentTypeList: paymentTypeList)
      }
      }, failure: nil)
  }
  
  
  static func fetchDeliverableCartItems(cartItemIds: [Int],
    address: String,
    addressType: AddressType,
    fetchSuccess: (cartItemIds: [Int]) -> Void) {
      if MyInfo.sharedMyInfo().isUser() {
        NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/deliverable-cart-items",
          parameter: ["cartItemIds": cartItemIds, "address": address, "addressType": addressType.rawValue],
          success: { (result) -> Void in
            var cartItemIds = [Int]()
            if let result = result as? [String: AnyObject],
              cartItems = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
                for cartItem in cartItems {
                  if let cartItemId = cartItem[kObjectPropertyKeyId] as? Int {
                    cartItemIds.append(cartItemId)
                  }
                }
                fetchSuccess(cartItemIds: cartItemIds)
            }
          }, failure: nil)
      }
  }
  
  static func fetchCalculatedPrice(price: Int, couponIds: [Int]? = nil, point: Int? = nil, fetchSuccess: (actualPrice: Int, discountPrice: Int) -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      var parameter = [String: AnyObject]()
      parameter["price"] = price
      parameter["couponIds"] = couponIds
      parameter["point"] = point
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/price-info",
        parameter: parameter,
        success: { (result) -> Void in
          if let result = result as? [String: AnyObject],
            data = result[kNetworkResponseKeyData] as? [String: AnyObject],
            actualPrice = data["actualPrice"] as? Int,
            discountPrice = data["discountPrice"] as? Int {
              fetchSuccess(actualPrice: actualPrice, discountPrice: discountPrice)
          }
        }, failure: nil)
    }
  }
  
  static func fetchAvailableCoupons(cartItemIds: [Int], couponList: CouponList, fetchSuccess: () -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/available-coupons",
        parameter: ["cartItemIds": cartItemIds],
        success: { (result) -> Void in
          if let result = result as? [String: AnyObject],
            data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
            couponList.assignObject(data)
              fetchSuccess()
          }
        }, failure: nil)
    }
  }
}
