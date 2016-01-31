
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
        cartItemIds.append(cartItemId)
      }
    }
    return cartItemIds
  }
}
