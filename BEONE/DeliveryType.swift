
import UIKit

class DeliveryType: BaseModel {
  var name: String?
  var reservable: Bool?
  var isDeliverable: Bool?
  var thumbnailImageUrl: String?
  
  override func assignObject(data: AnyObject) {
    thumbnailImageUrl = data["thumbnailImageUrl"] as? String
    id = data[kObjectPropertyKeyId] as? Int
    name = data["name"] as? String
    reservable = data["isReservable"] as? Bool
    isDeliverable = data["isDeliverable"] as? Bool
  }
  
  func isReservable() -> Bool {
    return reservable != nil && reservable! == true
  }
}
