
import UIKit

class ProductCategory: BaseModel {
  
  var name: String?
  var desc: String?
  var mainImageUrl: String?
  var products = Products()
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      name = data[kObjectPropertyKeyName] as? String
      desc = data[kObjectPropertyKeyDescription] as? String
      mainImageUrl = data["mainImageUrl"] as? String
      products.assignObject(data["products"])
    }
  }
}
