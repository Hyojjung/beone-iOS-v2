
import UIKit

class CartItem: BaseModel {
  var quantity: Int?
  var productId: Int?
  var productOrderableInfoId: Int?
  
  override func postUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/cart-items"
    }
    return "users/cart-items"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["quantity"] = quantity
    parameter["productId"] = productId
    parameter["productOrderableInfoId"] = productOrderableInfoId
    return parameter
  }
  
  override func postSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      if let data = result as? [String: AnyObject] {
        self.id = data[kObjectPropertyKeyId] as? Int
        self.postNotification(kNotificationPostCartItemSuccess)
      }
    }
  }
}
