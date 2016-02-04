
import UIKit

class CartItem: BaseModel {
  private let kCartItemPropertyKeyProduct = "product"
  private let kCartItemPropertyKeyProductOrderableInfo = "productOrderableInfo"
  
  var quantity = 1
  var product = Product()
  var productOrderableInfo = ProductOrderableInfo()
  var selectedOption: ProductOptionSetList?

  // MARK: - BaseModel Methods (Fetch)
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      if let qauntity = data[kCartItemPropertyKeyQuantity] as? Int {
        self.quantity = qauntity
      }
      if let productObject = data[kCartItemPropertyKeyProduct] {
        product.assignObject(productObject)
      }
      if let productOrderableInfoObject = data[kCartItemPropertyKeyProductOrderableInfo] {
        productOrderableInfo.assignObject(productOrderableInfoObject)
      }
      if let selectedOptionObject = data["productOptionSets"] as? [[String: AnyObject]] {
        if !selectedOptionObject.isEmpty {
          selectedOption = ProductOptionSetList()
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
