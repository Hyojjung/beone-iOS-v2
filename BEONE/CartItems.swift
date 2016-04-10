
import UIKit

let kCartItemPropertyKeyProductId = "productId"
let kCartItemPropertyKeyProductOrderableInfoId = "productOrderableInfoId"
let kCartItemPropertyKeyQuantity = "quantity"
let kCartItemPropertyKeyProductOptionSets = "productOptionSets"

class CartItems: BaseListModel {

  // MARK: - BaseModel Methods (Get)
  
  override func assignObject(data: AnyObject?) {
    if let cartItems = data as? [[String: AnyObject]] {
      list.removeAll()
      for cartItemObejct in cartItems {
        let cartItem = CartItem()
        cartItem.assignObject(cartItemObejct)
        list.appendObject(cartItem)
      }
    }
  }
  
  override func getUrl() -> String {
    return cartItemUrl()
  }
  
  // MARK: - BaseModel Methods (Post)

  override func postSuccess(result: AnyObject?) {
    if let result = result as? [String: AnyObject], data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for (index, cartItem) in self.list.enumerate() {
        cartItem.id = data[index][kObjectPropertyKeyId] as? Int
      }
    }
  }
  
  override func postUrl() -> String {
    return cartItemUrl()
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [[String: AnyObject]]()
    for cartItem in list as! [CartItem] {
      parameter.appendObject(cartItem.parameter())
    }
    return parameter
  }
}

// MARK: - Private Methods

extension CartItems {
  
  private func cartItemUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\((MyInfo.sharedMyInfo().userId)!)/cart-items"
    }
    return "cart-items"
  }
}
