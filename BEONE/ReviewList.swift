
import UIKit

enum ReviewListType {
  case Default
  case Simple
}

class ReviewList: BaseListModel {
  var type = ReviewListType.Default
  
  override func fetchUrl() -> String {
    if let productId = BEONEManager.selectedProduct?.id {
      return "products/\(productId)/reviews"
    }
    return "reviews"
  }
  
  override func fetchParameter() -> AnyObject? {
    return ["page": 1, "count": 1]
  }
  
  override func assignObject(data: AnyObject) {
    print(data)
  }
}
