
import UIKit

class Order: BaseModel {
  var senderName: String?
  var senderPhone: String?
  var isSecret = false
  var isDone = true
  var address = Address()
  var deliveryMemo: String?
  var price = 0
  var discountPrice = 0
  var actualPrice = 0
  var orderableItemSets = [OrderableItemSet]()
  var paymentInfoList = PaymentInfoList()
  var cartItemIds = [Int]()
  var title: String?
  var orderCode: String?
  var createdAt: NSDate?
  var usedPoint = 0
  var isCancellable = false
  
  override func fetchUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(id!)"
    }
    return "orders"
  }
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      if isDone {
        address.assignObject(data)
        deliveryMemo = data["deliveryMemo"] as? String
        senderName = data["senderName"] as? String
        senderPhone = data["senderPhone"] as? String
        orderCode = data["orderCode"] as? String
        if let isSecret = data["isSecret"] as? Bool {
          self.isSecret = isSecret
        }
      }
      
      assignOrderableItemSets(data)
      if let paymentInfos = data["paymentInfos"] {
        paymentInfoList.assignObject(paymentInfos)
      }
      id = data[kObjectPropertyKeyId] as? Int
      title = data["title"] as? String
      if let usedPoint = data["usedPoint"] as? Int {
        self.usedPoint = usedPoint
      }
      if let isCancellable = data["isCancellable"] as? Bool {
        self.isCancellable = isCancellable
      }
      if let price = data["price"] as? Int {
        self.price = price
      }
      if let discountPrice = data["discountPrice"] as? Int {
        self.discountPrice = discountPrice
      }
      if let actualPrice = data["actualPrice"] as? Int {
        self.actualPrice = actualPrice
      }
      if let createdAt = data["createdAt"] as? String {
        self.createdAt = createdAt.date()
      }
    }
  }
  
  func assignOrderableItemSets(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      var orderItemSetObjects: [[String: AnyObject]]? = nil
      if isDone {
        orderItemSetObjects = data["orderDeliveryItemSets"] as? [[String: AnyObject]]
      } else {
        orderItemSetObjects = data["orderableItemSets"] as? [[String: AnyObject]]
      }
      if let orderItemSetObjects = orderItemSetObjects {
        orderableItemSets.removeAll()
        for orderItemSetObject in orderItemSetObjects {
          let orderableItemset = OrderableItemSet()
          orderableItemset.isDone = isDone
          orderableItemset.assignObject(orderItemSetObject)
          orderableItemSets.append(orderableItemset)
          
        }
        orderableItemSets.sortInPlace{
          if $0.deliveryType.id == $1.deliveryType.id {
            return $0.shop.id > $1.shop.id
          } else {
            return $0.deliveryType.id > $1.deliveryType.id
          }
        }
      }
    }
  }
  
  func deliveryDateString() -> String {
    var deliveryDateString = String()
    for (i, orderItemSet) in orderableItemSets.enumerate() {
      for (index, orderItem) in orderItemSet.orderableItems.enumerate() {
        deliveryDateString += orderItem.productTitle!
        if index < orderItemSet.orderableItems.count - 1 {
          deliveryDateString += ", "
        } else {
          deliveryDateString += " : "
        }
      }
      if let selectedTimeRange = orderItemSet.selectedTimeRange {
        deliveryDateString += selectedTimeRange.dateNotation()
      } else {
        deliveryDateString += "택배배송"
      }
      if i < orderableItemSets.count - 1 {
        deliveryDateString += "\n"
      }
    }
    return deliveryDateString
  }
  
  func deliveryTypeCellHeight(index: Int) -> Bool {
    if let deliveryTypeId = orderableItemSets[index].deliveryType.id {
      for (idx, orderItemSet) in orderableItemSets.enumerate() where idx < index {
        if orderItemSet.deliveryType.id == deliveryTypeId {
          return false
        }
      }
    }
    return true
  }
  
  override func postUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders"
  }
  
  override func postSuccess() -> NetworkSuccess? {
    return {(result: AnyObject) -> Void in
      if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
        self.assignObject(data)
        self.postNotification(kNotificationPostOrderSuccess)
      }
    }
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["senderName"] = senderName
    parameter["senderPhone"] = senderPhone
    parameter["isSecret"] = isSecret
    parameter["receiverName"] = address.receiverName
    parameter["receiverPhone"] = address.receiverPhone
    parameter["receiverZipcode01"] = address.zipcode01
    parameter["receiverZipcode02"] = address.zipcode02
    parameter["receiverZonecode"] = address.zonecode
    parameter["receiverRoadAddress"] = address.roadAddress
    parameter["receiverJibunAddress"] = address.jibunAddress
    parameter["receiverAddressType"] = address.addressType?.rawValue
    parameter["receiverDetailAddress"] = address.detailAddress
    parameter["deliveryMemo"] = deliveryMemo
    parameter["cartItemIds"] = cartItemIds
    parameter["price"] = price
    parameter["discountPrice"] = discountPrice
    parameter["orderDeliveryItemSets"] = orderDeliveryItemSetParameter()
    return parameter
  }
  
  private func orderDeliveryItemSetParameter() -> [[String: AnyObject]] {
    var orderDeliveryItemSets = [[String: AnyObject]]()
    for orderableItemSet in orderableItemSets {
      var orderDeliveryItemSet = [String: AnyObject]()
      orderDeliveryItemSet["shopId"] = orderableItemSet.shop.id
      orderDeliveryItemSet["deliveryTypeId"] = orderableItemSet.deliveryType.id
      orderDeliveryItemSet["reservationStartDateTime"] =
        orderableItemSet.selectedTimeRange?.startDateTime?.serverDateString()
      orderDeliveryItemSet["reservationEndDateTime"] =
        orderableItemSet.selectedTimeRange?.endDateTime?.serverDateString()
      print(orderDeliveryItemSet)
      orderDeliveryItemSets.append(orderDeliveryItemSet)
    }
    return orderDeliveryItemSets
  }
}

extension Order {
  func prices() -> (totalItemPrice: Int, totalDeliveryPrice: Int) {
    var totalItemPrice = 0
    var totalDeliveryPrice = 0
    for orderableItemSet in orderableItemSets {
      for orderableItem in orderableItemSet.orderableItems {
        totalItemPrice += orderableItem.actualPrice
      }
      totalDeliveryPrice += orderableItemSet.deliveryPrice
    }
    return (totalItemPrice, totalDeliveryPrice)
  }
}
