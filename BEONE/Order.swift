
import UIKit

class Order: BaseModel {
  var senderName: String?
  var senderPhone: String?
  var isSecret: Bool?
  var address: Address?
  var deliveryMemo: String?
  var price: Int?
  var discountPrice: Int?
  var actualPrice: Int?
  var orderableItemSets = [OrderableItemSet]()
  var paymentInfos = [PaymentInfo]()
  var cartItemIds = [Int]()
  var title: String?
  var orderCode: String?
  var usedPoint: Int?
  
  override func assignObject(data: AnyObject) {
    if let orderableItemsetsObject = data["orderableItemSets"] as? [[String: AnyObject]] {
      orderableItemSets.removeAll()
      for orderableItemsetObject in orderableItemsetsObject {
        let orderableItemset = OrderableItemSet()
        orderableItemset.assignObject(orderableItemsetObject)
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
    
    if let paymentInfoObjects = data["paymentInfos"] as? [[String: AnyObject]] {
      paymentInfos.removeAll()
      for paymentInfoObject in paymentInfoObjects {
        let paymentInfo = PaymentInfo()
        paymentInfo.assignObject(paymentInfoObject)
        paymentInfos.append(paymentInfo)
      }
    }
    
    id = data[kObjectPropertyKeyId] as? Int
    title = data["title"] as? String
    senderName = data["senderName"] as? String
    senderPhone = data["senderPhone"] as? String
    orderCode = data["orderCode"] as? String
    usedPoint = data["usedPoint"] as? Int
    isSecret = data["isSecret"] as? Bool
    price = data["price"] as? Int
    discountPrice = data["discountPrice"] as? Int
    actualPrice = data["actualPrice"] as? Int
    address = Address()
    address?.assignObject(data)
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
    parameter["receiverName"] = address?.receiverName
    parameter["receiverPhone"] = address?.receiverPhone
    parameter["receiverZipcode01"] = address?.zipcode01
    parameter["receiverZipcode02"] = address?.zipcode02
    parameter["receiverZonecode"] = address?.zonecode
    parameter["receiverRoadAddress"] = address?.roadAddress
    parameter["receiverJibunAddress"] = address?.jibunAddress
    parameter["receiverAddressType"] = address?.addressType == .Road ?
      kAddressPropertyReceiverAddressTypeRoad : kAddressPropertyReceiverAddressTypeJibun
    parameter["receiverDetailAddress"] = address?.detailAddress
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
      orderDeliveryItemSets.append(orderDeliveryItemSet)
    }
    return orderDeliveryItemSets
  }
}
