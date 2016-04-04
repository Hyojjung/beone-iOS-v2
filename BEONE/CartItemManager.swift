
import UIKit

class CartItemManager: NSObject {
  static func removeCartItem(ids: [Int], removeSuccess: (() -> Void)? = nil) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestDelete("users/\((MyInfo.sharedMyInfo().userId)!)/cart-items",
        parameter: ["ids": ids],
        success: {(result) -> Void in
          removeSuccess?()
      })
    }
  }
  
  static func cartItemIds(cartItems: [BaseModel]) -> [Int] {
    var cartItemIds = [Int]()
    for cartItem in cartItems {
      if let cartItemId = cartItem.id {
        cartItemIds.appendObject(cartItemId)
      }
    }
    return cartItemIds
  }
  
  static func postCartItems(cartItems: [CartItem], postSuccess: () -> Void) {
    if MyInfo.sharedMyInfo().isUser() {
      var parameter = [[String: AnyObject]]()
      for cartItem in cartItems {
        parameter.appendObject(cartItem.parameter())
      }
      
      NetworkHelper.requestPost("users/\((MyInfo.sharedMyInfo().userId)!)/cart-items",
        parameter: parameter,
        success: {(result) -> Void in
          if let result = result as? [String: AnyObject],
            data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
              for cartItem in cartItems {
                for cartItemObject in data {
                  if cartItemObject["productId"] as? Int == cartItem.product.id &&
                    cartItemObject["productOrderableInfoId"] as? Int == cartItem.productOrderableInfo.id &&
                    cartItemObject["quantity"] as? Int == cartItem.quantity {
                      cartItem.id = cartItemObject[kObjectPropertyKeyId] as? Int
                      break
                  }
                }
              }
              postSuccess()
          }
        }, failure: nil)
    }
  }
}
