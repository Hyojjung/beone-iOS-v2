
import UIKit

class OrderableItem: BaseModel {
  var actualPrice = 0
  var quantity = 1
  lazy var availableTimeRangeList: AvailableTimeRangeList = {
    var availableTimeRangeList = AvailableTimeRangeList()
    return availableTimeRangeList
  }()
  lazy var product: Product = {
    var product = Product()
    return product
  }()
  var productOrderableInfo = ProductOrderableInfo()
  var itemImageUrls = [String]()
  var selectedOption: ProductOptionSetList?
  var cartItemId: Int?
  var productPrice: Int?
  var productImageUrl: String?
  var productTitle: String?
  var shopName: String?
  
  override func assignObject(data: AnyObject) {
    if let orderableItemset = data as? [String: AnyObject] {
      id = orderableItemset[kObjectPropertyKeyId] as? Int
      if let availableTimeRangesObject = orderableItemset["availableTimeRanges"] {
        availableTimeRangeList.assignObject(availableTimeRangesObject)
      }
      if let itemImageUrls = data["itemImageUrls"] as? [String] {
        self.itemImageUrls = itemImageUrls
      }
      if let actualPrice = data["actualPrice"] as? Int {
        self.actualPrice = actualPrice
      }
      if let quantity = data["quantity"] as? Int {
        self.quantity = quantity
      }
      productPrice = data["productPrice"] as? Int
      cartItemId = data["cartItemId"] as? Int
      productImageUrl = data["productImageUrl"] as? String
      productTitle = data["productTitle"] as? String
      
      if let productObject = orderableItemset["product"] {
        product.assignObject(productObject)
      }
      
      if let productOrderableInfoObject = orderableItemset["productOrderableInfo"] {
        productOrderableInfo.assignObject(productOrderableInfoObject)
      }
      
      if let selectedOptionObject = data["productOptionSets"] as? [[String: AnyObject]] {
        selectedOption = ProductOptionSetList()
        selectedOption?.assignObject(selectedOptionObject)
      }
    }
  }
}
