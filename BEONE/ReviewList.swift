
import UIKit

enum ReviewListType {
  case Default
  case Simple
}

class ReviewList: BaseListModel {
  var type = ReviewListType.Default
  var productId: Int?
  
  override func getUrl() -> String {
    if let productId = productId {
      return "products/\(productId)/reviews"
    }
    return "reviews"
  }
  
  override func getParameter() -> AnyObject? {
    return ["page": 1, "count": 1]
  }
  
  override func assignObject(data: AnyObject) {
    print(data)
  }
}
