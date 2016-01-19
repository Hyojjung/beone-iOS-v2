
import UIKit

let kCartItemPropertyKeyProductId = "productId"
let kCartItemPropertyKeyProductOrderableInfoId = "productOrderableInfoId"
let kCartItemPropertyKeyQuantity = "quantity"
let kCartItemPropertyKeyProductOptionSets = "productOptionSets"

class CartItemList: BaseListModel {
    
  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject) {
    if let cartItemList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      for cartItemObejct in cartItemList {
        let cartItem = CartItem()
        cartItem.assignObject(cartItemObejct)
        list.append(cartItem)
      }
      postNotification(kNotificationFetchCartListSuccess)
    }
  }
  
  override func fetchUrl() -> String {
    return cartItemUrl()
  }
  
  // MARK: - BaseModel Methods (Post)
  
  override func postUrl() -> String {
    return cartItemUrl()
  }
  
  override func postParameter() -> AnyObject? {
    return parameter()
  }
  
  override func postSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      if let result = result as? [String: AnyObject], data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
        for (index, cartItem) in self.list.enumerate() {
          cartItem.id = data[index][kObjectPropertyKeyId] as? Int
        }
        self.postNotification(kNotificationPostCartItemSuccess)
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
  
  // MARK: - Private Methods
  
  private func parameter() -> [[String: AnyObject]] {
    var parameter = [[String: AnyObject]]()
    for cartItem in list as! [CartItem] {
      parameter.append(cartItem.parameter())
    }
    return parameter
  }
  
  // MARK: - Public Methods
  
  func cartItemIds() -> [Int] {
    var cartItemIds = [Int]()
    for cartItem in list {
      if let cartItemId = cartItem.id {
        cartItemIds.append(cartItemId)
      }
    }
    return cartItemIds
  }
}
