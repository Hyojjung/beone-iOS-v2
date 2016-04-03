
import UIKit

enum ReviewsType {
  case Default
  case Simple
}

class Reviews: BaseListModel {
  var type = ReviewsType.Default
  var productId: Int?
  
  override func getUrl() -> String {
    if let productId = productId {
      return "products/\(productId)/reviews"
    }
    return "reviews"
  }
//  
//  override func getParameter() -> AnyObject? {
//    return ["page": 1, "count": 1]
//  }
//  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let reviews = data as? [[String: AnyObject]] {
      for reviewObject in reviews {
        let review = Review()
        review.assignObject(reviewObject)
        list.appendObject(review)
      }
    }
  }
}
