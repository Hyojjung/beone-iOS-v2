
import UIKit

class ProductCategory: BaseModel {
  
  var name: String?
  var summary: String?
  var mainImageUrl: String?
  var products = ProductList()
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      name = data["name"] as? String
      summary = data["description"] as? String
      mainImageUrl = data["mainImageUrl"] as? String
      if let products = data["products"] as? [[String: AnyObject]] {
        self.products.assignObject(products)
      }
    }
  }
}
