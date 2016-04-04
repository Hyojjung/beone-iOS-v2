
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
    if let result = result as? [String: AnyObject],
      data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for cartItem in list as! [CartItem] {
        for cartItemObject in data {
          if cartItemObject["productId"] as? Int == cartItem.product.id &&
            cartItemObject["productOrderableInfoId"] as? Int == cartItem.productOrderableInfo.id &&
            cartItemObject["quantity"] as? Int == cartItem.quantity {
            cartItem.id = cartItemObject[kObjectPropertyKeyId] as? Int
            break
          }
        }
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


// MARK: - Public Methods

extension CartItems {

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
