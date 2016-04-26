
import UIKit

class ReservationDateOption: BaseModel {
  var name: String?
  var value: String?
  var display: String?
  var isSelected = false
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      name = data[kObjectPropertyKeyName] as? String
      display = data["display"] as? String
      value = data["value"] as? String
      if let isSelected = data["isSelected"] as? Bool {
        self.isSelected = isSelected
      }
    }
  }
}
