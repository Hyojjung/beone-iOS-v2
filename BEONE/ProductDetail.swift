
import UIKit

enum ProductDetailType: String {
  case Image = "1"
  case Text = "2"
  case Title = "3"
}

class ProductDetail: BaseModel {
  
  private let kProductDetailPropertyKeyContent = "content"
  private let kProductDetailPropertyKeyDetailType = "detailType"
  
  var content: String?
  var detailType: ProductDetailType?
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      content = data[kProductDetailPropertyKeyContent] as? String
      if let detailTypeRawValue = data[kProductDetailPropertyKeyDetailType] as? String {
        detailType = ProductDetailType(rawValue: detailTypeRawValue)
      }
    }
  }
}
