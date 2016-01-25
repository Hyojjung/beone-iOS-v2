
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
}
