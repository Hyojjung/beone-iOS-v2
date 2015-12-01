
import UIKit

class Order: BaseModel {
  var senderName: String?
  var senderPhone: String?
  var isSecret: Bool?
  var address: Address?
  var deliveryMemo: String?
  var price: Int?
  var actualPrice: Int?
  var orderableItemSets = [OrderableItemSet]()
  
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
    
    price = data["price"] as? Int
    actualPrice = data["actualPrice"] as? Int
    
    postNotification(kNotificationFetchOrderSuccess)
  }
  
  override func copy() -> AnyObject {
    let order = Order()
    order.price = price
    order.orderableItemSets = orderableItemSets.map { ($0.copy() as! OrderableItemSet) }
    return order
  }
}
