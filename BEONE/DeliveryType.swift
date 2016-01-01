
import UIKit

class DeliveryType: BaseModel {
  var name: String?
  var isReservable = false
  var isDeliverable: Bool?
  var thumbnailImageUrl: String?
  
  override func assignObject(data: AnyObject) {
    thumbnailImageUrl = data["thumbnailImageUrl"] as? String
    id = data[kObjectPropertyKeyId] as? Int
    name = data["name"] as? String
    if let isReservable = data["isReservable"] as? Bool {
      self.isReservable = isReservable
    }
    isDeliverable = data["isDeliverable"] as? Bool
  }
}
