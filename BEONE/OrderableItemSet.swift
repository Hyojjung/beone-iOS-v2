
import UIKit

class OrderableItemSet: BaseModel {
  var availableTimeRangeList = AvailableTimeRangeList()
  var selectedTimeRange: AvailableTimeRange?
  var orderableItems = [OrderableItem]()
  var deliveryPrice = 0
  let location = Location()
  let deliveryType = DeliveryType()
  let shop = Shop()
  var actualPrice: Int?
  lazy var order: Order = {
    let order = Order()
    return order
  }()
  
  var statusName: String?
  var isCancellable = false
  var isCompletable = false
  var isRefundable = false
  var isReturnable = false
  
  override func assignObject(data: AnyObject) {
    if let orderableItemSet = data as? [String: AnyObject] {
      id = orderableItemSet[kObjectPropertyKeyId] as? Int

      assignAvailableTimeRanges(orderableItemSet["availableTimeRanges"])
      assignStatus(orderableItemSet["status"])
      
      var orderItemObjects = orderableItemSet["orderableItems"] as? [[String: AnyObject]]
      if orderItemObjects == nil {
        orderItemObjects = orderableItemSet["orderItems"] as? [[String: AnyObject]]
      }
      
      if let shopObject = orderableItemSet["shop"] {
        shop.assignObject(shopObject)
      }
      
      if let orderItemObjects = orderItemObjects {
        orderableItems.removeAll()
        for orderableItemObject in orderItemObjects {
          let orderableItem = OrderableItem()
          orderableItem.shopName = shop.name
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

      if let order = orderableItemSet["order"] {
        self.order.assignObject(order)
      }
    }
  }
  
  func assignAvailableTimeRanges(availableTimeRangesObject: AnyObject?) {
    if let availableTimeRangesObject = availableTimeRangesObject as? [[String: AnyObject]] {
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
  }
  
  func assignStatus(status: AnyObject?) {
    if let statusObject = status as? [String: AnyObject] {
      statusName = statusObject["name"] as? String
      if let isCancellable = statusObject["isCancellable"] as? Bool {
        self.isCancellable = isCancellable
      }
      if let isCompletable = statusObject["isCompletable"] as? Bool {
        self.isCompletable = isCompletable
      }
      if let isRefundable = statusObject["isRefundable"] as? Bool {
        self.isRefundable = isRefundable
      }
      if let isReturnable = statusObject["isReturnable"] as? Bool {
        self.isReturnable = isReturnable
      }
    }
  }
}

