
import UIKit

class FavoriteProduct: BaseModel {
  
  var productId: Int?
  
  override func postUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/favorite-products"
    }
    return "favorite-products"
  }
  
  override func postParameter() -> AnyObject? {
    var pararmeter = [String: Int]()
    pararmeter["productId"] = productId
    return pararmeter
  }
  
  override func postSuccess(result: AnyObject?) {
    if var favoriteProductIds = NSUserDefaults.standardUserDefaults().objectForKey(kFavoriteProductIds) as? [Int] {
      favoriteProductIds.appendObject(productId)
    } else {
      let favoriteProductIds = [productId!]
      NSUserDefaults.standardUserDefaults().setObject(favoriteProductIds, forKey: kFavoriteProductIds)
    }
  }
}
