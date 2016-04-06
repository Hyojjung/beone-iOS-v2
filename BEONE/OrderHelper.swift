
import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(order: Order, getSuccess: () -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": order.cartItemIds], success: { (result) -> Void in
          order.assignObject(result[kNetworkResponseKeyData])
          getSuccess()
        }, failure: nil)
    }
  }
  
  static func fetchPaymentTypes(getSuccess: (paymentTypes: PaymentTypes) -> Void) {
    NetworkHelper.requestGet("payment-types", parameter: ["isVisible": true], success: { (result) -> Void in
      let paymentTypes = PaymentTypes()
      if let paymentTypeObjects = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
        for paymentTypeObject in paymentTypeObjects {
          let paymentType = PaymentType()
          paymentType.assignObject(paymentTypeObject)
          paymentTypes.list.appendObject(paymentType)
        }
        getSuccess(paymentTypes: paymentTypes)
      }
      }, failure: nil)
  }
  
  
  static func fetchDeliverableCartItems(cartItemIds: [Int],
    address: String,
    addressType: AddressType,
    getSuccess: (cartItemIds: [Int]) -> Void) {
      if MyInfo.sharedMyInfo().isUser() {
        NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/deliverable-cart-items",
          parameter: ["cartItemIds": cartItemIds, "address": address, "addressType": addressType.rawValue],
          success: { (result) -> Void in
            var cartItemIds = [Int]()
            if let result = result as? [String: AnyObject],
              cartItems = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
                for cartItem in cartItems {
                  if let cartItemId = cartItem[kObjectPropertyKeyId] as? Int {
                    cartItemIds.appendObject(cartItemId)
                  }
                }
                getSuccess(cartItemIds: cartItemIds)
            }
          }, failure: nil)
      }
  }
  
  static func fetchCalculatedPrice(price: Int, couponIds: [Int]? = nil, point: Int? = nil, getSuccess: (actualPrice: Int, discountPrice: Int) -> Void) {
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
              getSuccess(actualPrice: actualPrice, discountPrice: discountPrice)
          }
        }, failure: nil)
    }
  }
  
  static func fetchAvailableCoupons(cartItemIds: [Int], coupons: Coupons, getSuccess: () -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/available-coupons",
        parameter: ["cartItemIds": cartItemIds],
        success: { (result) -> Void in
          coupons.isUsableCoupons = true
          coupons.assignObject(result[kNetworkResponseKeyData])
          getSuccess()
        }, failure: nil)
    }
  }
}
