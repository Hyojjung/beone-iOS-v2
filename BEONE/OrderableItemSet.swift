
import UIKit

class OrderableItemSet: BaseModel {
  
  var actualPrice = 0
  var deliveryPrice = 0
  var selectedTimeRange: AvailableTimeRange?
  var title: String?
  
  lazy var progresses: [OrderItemSetProgress] = {
    var progresses = [OrderItemSetProgress]()
    return progresses
  }()
  lazy var orderableItems: [OrderableItem] = {
    var orderableItems = [OrderableItem]()
    return orderableItems
  }()
  lazy var availableTimeRangeList: AvailableTimeRangeList = {
    let availableTimeRangeList = AvailableTimeRangeList()
    return availableTimeRangeList
  }()
  lazy var location: Location = {
    let location = Location()
    return location
  }()
  lazy var deliveryType: DeliveryType = {
    let deliveryType = DeliveryType()
    return deliveryType
  }()
  lazy var shop: Shop = {
    let shop = Shop()
    return shop
  }()
  lazy var order: Order = {
    let order = Order()
    return order
  }()
  lazy var orderDeliveryInfo: OrderDeliveryInfo = {
    let orderDeliveryInfo = OrderDeliveryInfo()
    return orderDeliveryInfo
  }()
  
  var statusName: String?
  var isCancellable = false
  var isCompletable = false
  var isRefundable = false
  var isReturnable = false
  var isDone = true
  
  override func assignObject(data: AnyObject) {
    if let orderableItemSet = data as? [String: AnyObject] {
      id = orderableItemSet[kObjectPropertyKeyId] as? Int
      title = orderableItemSet["title"] as? String
      
      if let reservation = orderableItemSet["reservation"] as? [String: AnyObject] {
        selectedTimeRange = AvailableTimeRange()
        selectedTimeRange?.assignObject(reservation)
      }
      if let shop = orderableItemSet["shop"] {
        self.shop.assignObject(shop)
      }
      
      assignAvailableTimeRanges(orderableItemSet["availableTimeRanges"])
      assignStatus(orderableItemSet["status"])
      assignOrderItems(orderableItemSet)
      assignProgresses(orderableItemSet["progresses"])
      
      if let actualPrice = orderableItemSet["actualPrice"] as? Int {
        self.actualPrice = actualPrice
      }
      if let deliveryPriceInfo = orderableItemSet["deliveryPriceInfo"] as? [String: AnyObject],
        deliveryPrice = deliveryPriceInfo["actualPrice"] as? Int {
          self.deliveryPrice = deliveryPrice
      }
      if let location = orderableItemSet["location"] {
        self.location.assignObject(location)
      }
      if let deliveryType = orderableItemSet["deliveryType"] {
        self.deliveryType.assignObject(deliveryType)
      }
      if let order = orderableItemSet["order"] {
        self.order.assignObject(order)
      } else {
        order.id = orderableItemSet["orderId"] as? Int
      }
      if let orderDeliveryInfo = orderableItemSet["orderDeliveryInfo"] {
        self.orderDeliveryInfo.assignObject(orderDeliveryInfo)
      }
    }
  }
  
  override func putUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(order.id!)/order-delivery-item-sets/\(id!)/status"
    }
    return "users/orders/order-delivery-item-sets/status"
  }
  
  override func putParameter() -> AnyObject? {
    return ["statusId": 16]
  }
}

extension OrderableItemSet {
  
  private func assignOrderItems(data: [String: AnyObject]) {
    let orderItemObjects: [[String: AnyObject]]
    if isDone {
      orderItemObjects = data["orderItems"] as! [[String: AnyObject]]
    } else {
      orderItemObjects = data["orderableItems"] as! [[String: AnyObject]]
    }
    orderableItems.removeAll()
    for orderableItemObject in orderItemObjects {
      let orderableItem = OrderableItem()
      orderableItem.shopName = shop.name
      orderableItem.assignObject(orderableItemObject)
      orderableItems.append(orderableItem)
    }
  }
  
  private func assignAvailableTimeRanges(availableTimeRangesObject: AnyObject?) {
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
  
  private func assignStatus(status: AnyObject?) {
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

// MARK: - Progress Methods

extension OrderableItemSet {

  private func assignProgresses(progressObjects: AnyObject?) {
    if let progressObjects = progressObjects as? [[String: AnyObject]] {
      var progresses = [OrderItemSetProgress]()
      for progressObject in progressObjects {
        let progress = OrderItemSetProgress()
        progress.assignObject(progressObject)
        progresses.append(progress)
      }
      // assign
      self.progresses.removeAll()
      rangeProgresses(with: .Waiting)
      rangeProgresses(with: .Progressing)
      rangeProgresses(with: .Done)
      // range
      organizeProgressesStatus()
    }
  }
  
  private func rangeProgresses(with progressType: ProgressType) {
    for progress in progresses {
      if progress.progressType == progressType {
        self.progresses.append(progress)
        break
      }
    }
  }
  
  private func organizeProgressesStatus() {
    for (index, progress) in self.progresses.enumerate() {
      if progress.progressedAt != nil {
        progress.progressStatus = .Done
        if progresses.isInRange(index) {
          let nextProgress = self.progresses[index + 1]
          if nextProgress.progressedAt == nil {
            progress.progressStatus = .Progressing
          }
        } else {
          progress.progressStatus = .Progressing
        }
      }
    }
  }
}

