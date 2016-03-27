
import UIKit

class ReservationDateOption: BaseModel {
  var name: String?
  var value: String?
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      name = data[kObjectPropertyKeyName] as? String
      value = data["value"] as? String      
    }
  }
}
