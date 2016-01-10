
import UIKit

class OrderableItemSet: BaseModel {
  var availableTimeRangeList = AvailableTimeRangeList()
  var selectedTimeRange: AvailableTimeRange?
  var orderableItems = [OrderableItem]()
  var deliveryPrice = 0
  let location = Location()
  let deliveryType = DeliveryType()
  let shop = Shop()
  
  override func assignObject(data: AnyObject) {
    if let orderableItemSet = data as? [String: AnyObject] {
      id = orderableItemSet[kObjectPropertyKeyId] as? Int
      if let availableTimeRangesObject = orderableItemSet["availableTimeRanges"] as? [[String: AnyObject]] {
        var availableTimeRanges = [AvailableTimeRange]()
        for availableTimeRangeObject in availableTimeRangesObject {
          let availableTimeRange = AvailableTimeRange()
          availableTimeRange.assignObject(availableTimeRangeObject)
          availableTimeRanges.append(availableTimeRange)
        }
        availableTimeRanges.sortInPlace {
          return $0.startDateTime!.compare($1.startDateTime!) == .OrderedAscending
        }
        availableTimeRangeList.list = availableTimeRanges
      }
      
      if let orderableItemsObject = orderableItemSet["orderableItems"] as? [[String: AnyObject]] {
        orderableItems.removeAll()
        for orderableItemObject in orderableItemsObject {
          let orderableItem = OrderableItem()
          orderableItem.assignObject(orderableItemObject)
          orderableItems.append(orderableItem)
        }
      }
      
      if let deliveryPriceInfo = orderableItemSet["deliveryPriceInfo"] as? [String: AnyObject],
        deliveryPrice = deliveryPriceInfo["actualPrice"] as? Int {
        self.deliveryPrice = deliveryPrice
      }
      
      if let locationObject = orderableItemSet["location"] {
        location.assignObject(locationObject)
      }
      
      if let deliveryTypeObject = orderableItemSet["deliveryType"] {
        deliveryType.assignObject(deliveryTypeObject)
      }
      
      if let shopObject = orderableItemSet["shop"] {
        shop.assignObject(shopObject)
      }
    }
  }
}

