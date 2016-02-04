
import UIKit

class OrderableItem: BaseModel {
  var actualPrice = 0
  var quantity = 1
  var availableTimeRangeList = AvailableTimeRangeList()
  let product = Product()
  var cartItemId: Int?
  var productPrice: Int?
  var productImageUrl: String?
  var productTitle: String?
  var shopName: String?
  var productOrderableInfo = ProductOrderableInfo()
  var itemImageUrls = [String]()
  var selectedOption: ProductOptionSetList?

  override func assignObject(data: AnyObject) {
    if let orderableItemset = data as? [String: AnyObject] {
      id = orderableItemset[kObjectPropertyKeyId] as? Int
      if let availableTimeRangesObject = orderableItemset["availableTimeRanges"] as? [[String: AnyObject]] {
        availableTimeRangeList.list.removeAll()
        for availableTimeRangeObject in availableTimeRangesObject {
          let availableTimeRange = AvailableTimeRange()
          availableTimeRange.assignObject(availableTimeRangeObject)
          availableTimeRangeList.list.append(availableTimeRange)
        }
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
  
  func availableDeliveryDatesString() -> String {
    var deliveryDatesString = String()
    var deliveryMonthes = [Int]()
    for availableDeliveryDate in availableTimeRangeList.availableDeliveryDates() {
        if deliveryMonthes.contains(availableDeliveryDate.0) {
          deliveryDatesString += ", \(availableDeliveryDate.1)일"
        } else {
          deliveryMonthes.append(availableDeliveryDate.0)
          deliveryDatesString += "\(availableDeliveryDate.0)월 \(availableDeliveryDate.1)일"
        } // for delivery date tuple 0 : month, 1 : day
    }
    return deliveryDatesString
  }
}
