
import UIKit

class CartItem: BaseModel {
  private let kCartItemPropertyKeyProductId = "productId"
  private let kCartItemPropertyKeyProduct = "product"
  private let kCartItemPropertyKeyProductOrderableInfo = "productOrderableInfo"
  private let kCartItemPropertyKeyProductOrderableInfoId = "productOrderableInfoId"
  private let kCartItemPropertyKeyQuantity = "quantity"
  
  var quantity: Int?
  var product = Product()
  var productOrderableInfo = ProductOrderableInfo()
  
  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      quantity = data[kCartItemPropertyKeyQuantity] as? Int
      if let productObject = data[kCartItemPropertyKeyProduct] {
        product.assignObject(productObject)
      }
      if let productOrderableInfoObject = data[kCartItemPropertyKeyProductOrderableInfo] {
        productOrderableInfo.assignObject(productOrderableInfoObject)
      }
    }
  }
  
  // MARK: - BaseModel Methods (Post)
  
  override func postUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/cart-items"
    }
    return "users/cart-items"
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
  
  // MARK: - BaseModel Methods (Put)
  
  override func putUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/cart-items/\(id!)"
    }
    return "cart-items"
  }
  
  override func putParameter() -> AnyObject? {
    return parameter()
  }
  
  override func putSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      self.postNotification(kNotificationPostCartItemSuccess)
    }
  }
  
  // MARK: - Private Methods
  
  private func parameter() -> [String: AnyObject] {
    var parameter = [String: AnyObject]()
    parameter[kCartItemPropertyKeyQuantity] = quantity
    parameter[kCartItemPropertyKeyProductId] = product.id
    parameter[kCartItemPropertyKeyProductOrderableInfoId] = productOrderableInfo.id
    return parameter
  }
}
