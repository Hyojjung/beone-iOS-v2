
import UIKit

enum ProductDetailType: String {
  case Image = "image"
  case Text = "text"
  case Title = "title"
}

class ProductDetail: BaseModel {
  
  private let kProductDetailPropertyKeyContent = "content"
  private let kProductDetailPropertyKeyDetailType = "detailType"
  
  var content: String?
  var detailType: ProductDetailType?
  var height: CGFloat?
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      content = data[kProductDetailPropertyKeyContent] as? String
      if let detailTypeRawValue = data[kProductDetailPropertyKeyDetailType] as? String {
        detailType = ProductDetailType(rawValue: detailTypeRawValue)
      }
      if detailType == .Image {
        height = 300
      }
    }
  }
}
