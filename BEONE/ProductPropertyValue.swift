
import UIKit

class ProductPropertyValue: BaseModel, SearchValueProtocol {
  var color: UIColor?
  var subTitle: String?
  var name: String?
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      name = data["name"] as? String
      subTitle = data["description"] as? String
      if let color = data["color"] as? String {
        self.color = UIColor(rgba: color)
      }
    }
  }
}
