
import UIKit

class ProductOrderableInfo: BaseModel {
  var price: Int?
  var name: String?
  
  override func assignObject(data: AnyObject) {
    if let productOrderableInfo = data as? [String: AnyObject] {
      id = productOrderableInfo[kObjectPropertyKeyId] as? Int
      price = productOrderableInfo["actualPrice"] as? Int
      if let deliveryType = productOrderableInfo["deliveryType"] as? [String: AnyObject] {
        name = deliveryType["name"] as? String
      }
    }
  }
}
