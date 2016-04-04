
import UIKit

class CartItem: BaseModel {
  private let kCartItemPropertyKeyProduct = "product"
  private let kCartItemPropertyKeyProductOrderableInfo = "productOrderableInfo"
  
  var quantity = 1
  var product = Product()
  var productOrderableInfo = ProductOrderableInfo()
  var selectedOption: ProductOptionSets?
  
  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject?) {
    if let cartItem = data as? [String: AnyObject] {
      id = cartItem[kObjectPropertyKeyId] as? Int
      if let qauntity = cartItem[kCartItemPropertyKeyQuantity] as? Int {
        self.quantity = qauntity
      }
      product.assignObject(cartItem[kCartItemPropertyKeyProduct])
      productOrderableInfo.assignObject(cartItem[kCartItemPropertyKeyProductOrderableInfo])
      if let selectedOptionObject = cartItem["productOptionSets"] as? [[String: AnyObject]] {
        if !selectedOptionObject.isEmpty {
          selectedOption = ProductOptionSets()
          selectedOption?.assignObject(selectedOptionObject)
        }
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
  
  // MARK: - Private Methods
  
  func parameter() -> [String: AnyObject] {
    var parameter = [String: AnyObject]()
    parameter[kCartItemPropertyKeyQuantity] = quantity
    parameter[kCartItemPropertyKeyProductId] = product.id
    parameter[kCartItemPropertyKeyProductOrderableInfoId] = productOrderableInfo.id
    parameter[kCartItemPropertyKeyProductOptionSets] = selectedOption?.serverFormat()
    return parameter
  }
}
