
import UIKit

class OrderableItem: BaseModel {
  var price: Int?
  var quantity: Int?
  var availableTimeRangeList = AvailableTimeRangeList()
  let product = Product()
  var cartItemId: Int?
  var productOrderableInfo = ProductOrderableInfo()
  
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
      
      price = data["actualPrice"] as? Int
      quantity = data["quantity"] as? Int
      cartItemId = data["cartItemId"] as? Int
      
      if let productObject = orderableItemset["product"] {
        product.assignObject(productObject)
      }
      
      if let productOrderableInfoObject = orderableItemset["productOrderableInfo"] {
        productOrderableInfo.assignObject(productOrderableInfoObject)
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
