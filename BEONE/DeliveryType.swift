
import UIKit

class DeliveryType: BaseModel {
  var name: String?
  var isReservable = false
  var thumbnailImageUrl: String?
  
  override func assignObject(data: AnyObject?) {
    if let deliveryType = data as? [String: AnyObject] {
      thumbnailImageUrl = deliveryType["thumbnailImageUrl"] as? String
      id = deliveryType[kObjectPropertyKeyId] as? Int
      name = deliveryType[kObjectPropertyKeyName] as? String
      if let isReservable = deliveryType["isReservable"] as? Bool {
        self.isReservable = isReservable
      }
    }
  }
}
