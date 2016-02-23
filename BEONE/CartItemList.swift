
import UIKit

let kCartItemPropertyKeyProductId = "productId"
let kCartItemPropertyKeyProductOrderableInfoId = "productOrderableInfoId"
let kCartItemPropertyKeyQuantity = "quantity"
let kCartItemPropertyKeyProductOptionSets = "productOptionSets"

class CartItemList: BaseListModel {
    
  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject?) {
    if let cartItemList = data as? [[String: AnyObject]] {
      list.removeAll()
      for cartItemObejct in cartItemList {
        let cartItem = CartItem()
        cartItem.assignObject(cartItemObejct)
        list.append(cartItem)
      }
    }
  }
  
  override func getUrl() -> String {
    return cartItemUrl()
  }
  
  // MARK: - BaseModel Methods (Post)

  override func postSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      if let result = result as? [String: AnyObject], data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
        for (index, cartItem) in self.list.enumerate() {
          cartItem.id = data[index][kObjectPropertyKeyId] as? Int
        }
      }
    }
  }
  
  // MARK: - Private Methods
  
  private func cartItemUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\((MyInfo.sharedMyInfo().userId)!)/cart-items"
    }
    return "cart-items"
  }
}
