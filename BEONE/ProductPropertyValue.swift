
import UIKit

class ProductPropertyValue: BaseModel, SearchValueProtocol {
  var color: UIColor?
  var desc: String?
  var name: String?
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      name = data[kObjectPropertyKeyName] as? String
      desc = data[kObjectPropertyKeyDescription] as? String
      if let color = data["color"] as? String {
        self.color = UIColor(rgba: color)
      }
    }
  }
}
