
import UIKit

let kCartItemPropertyKeyProductId = "productId"
let kCartItemPropertyKeyProductOrderableInfoId = "productOrderableInfoId"
let kCartItemPropertyKeyQuantity = "quantity"
let kCartItemPropertyKeyProductOptionSets = "productOptionSets"

class CartItemList: BaseListModel {
  
  var selectedCartItemIds = [Int]()
  
  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject) {
    if let cartItemList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      selectedCartItemIds.removeAll()
      for cartItemObejct in cartItemList {
        let cartItem = CartItem()
        cartItem.assignObject(cartItemObejct)
        list.append(cartItem)
        selectedCartItemIds.append(cartItem.id!)
      }
      postNotification(kNotificationFetchCartListSuccess)
    }
  }
  
  override func fetchUrl() -> String {
    return cartItemUrl()
  }
  
  // MARK: - BaseModel Methods (Delete)
  
  override func deleteUrl() -> String {
    return cartItemUrl()
  }
  
  override func deleteParameter() -> AnyObject? {
    return ["ids": selectedCartItemIds]
  }
  
  override func deleteSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      self.fetch()
    }
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
      if let data = result as? [String: AnyObject] {
        self.id = data[kObjectPropertyKeyId] as? Int
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
