
import UIKit

class OrderableItemSet: BaseModel {
  var availableTimeRanges = [AvailableTimeRange]()
  var orderableItems = [OrderableItem]()
  var deliveryPrice: Int?
  let location = Location()
  let deliveryType = DeliveryType()
  let shop = Shop()
  
  override func assignObject(data: AnyObject) {
    if let orderableItemset = data as? [String: AnyObject] {
      id = orderableItemset[kObjectPropertyKeyId] as? Int
      if let availableTimeRangesObject = orderableItemset["availableTimeRanges"] as? [[String: AnyObject]] {
        availableTimeRanges.removeAll()
        for availableTimeRangeObject in availableTimeRangesObject {
          let availableTimeRange = AvailableTimeRange()
          availableTimeRange.assignObject(availableTimeRangeObject)
          availableTimeRanges.append(availableTimeRange)
        }
      }
      
      if let orderableItemsObject = orderableItemset["orderableItems"] as? [[String: AnyObject]] {
        orderableItems.removeAll()
        for orderableItemObject in orderableItemsObject {
          let orderableItem = OrderableItem()
          orderableItem.assignObject(orderableItemObject)
          orderableItems.append(orderableItem)
        }
      }
      
      if let deliveryPriceInfo = orderableItemset["deliveryPriceInfo"] as? [String: AnyObject] {
        deliveryPrice = deliveryPriceInfo["actualPrice"] as? Int
      }
      
      if let locationObject = orderableItemset["location"] {
        location.assignObject(locationObject)
      }
      
      if let deliveryTypeObject = orderableItemset["deliveryType"] {
        deliveryType.assignObject(deliveryTypeObject)
      }
      
      if let shopObject = orderableItemset["shop"] {
        shop.assignObject(shopObject)
      }
    }
  }
  
  override func copy() -> AnyObject {
    let orderableItemSet = OrderableItemSet()
    orderableItemSet.orderableItems = orderableItems.map { ($0.copy() as! OrderableItem) }
    orderableItemSet.deliveryPrice = deliveryPrice
    return orderableItemSet
  }
}

