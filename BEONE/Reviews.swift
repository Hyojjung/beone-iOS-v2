
import UIKit

enum ReviewsType {
  case Default
  case Simple
}

class Reviews: BaseListModel {
  var type = ReviewsType.Default
  var productId: Int?
  var isRecentThree: Bool = false
  
  override func getUrl() -> String {
    if let productId = productId {
      return "products/\(productId)/reviews"
    }
    return "reviews"
  }
  
  override func getParameter() -> AnyObject? {
    if isRecentThree {
      var parameter = [String: AnyObject]()
      parameter["page"] = 1
      parameter["count"] = 3
      return parameter
    }
    return nil
  }
  
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
