
import UIKit

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
  
  // MARK: - Private Methods

  private func cartItemUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\((MyInfo.sharedMyInfo().userId)!)/cart-items"
    }
    return "cart-items"
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
