
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
  
  override func assignObject(data: AnyObject?) {
    if let orderableItemset = data as? [String: AnyObject] {
      id = orderableItemset[kObjectPropertyKeyId] as? Int
      availableTimeRangeList.assignObject(orderableItemset["availableTimeRanges"])
      if let itemImageUrls = orderableItemset["itemImageUrls"] as? [String] {
        self.itemImageUrls = itemImageUrls
      }
      if let actualPrice = orderableItemset["actualPrice"] as? Int {
        self.actualPrice = actualPrice
      }
      if let quantity = orderableItemset["quantity"] as? Int {
        self.quantity = quantity
      }
      productPrice = orderableItemset["productPrice"] as? Int
      cartItemId = orderableItemset["cartItemId"] as? Int
      productImageUrl = orderableItemset["productImageUrl"] as? String
      productTitle = orderableItemset["productTitle"] as? String
      
      product.assignObject(orderableItemset["product"])
      productOrderableInfo.assignObject(orderableItemset["productOrderableInfo"])
      
      if let selectedOptionObject = orderableItemset["productOptionSets"] as? [[String: AnyObject]] {
        selectedOption = ProductOptionSetList()
        selectedOption?.assignObject(selectedOptionObject)
      }
    }
  }
}
