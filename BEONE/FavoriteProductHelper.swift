
import UIKit

class FavoriteProductHelper {
  
  static func postFavoriteProduct(productId: Int?, success: () -> Void) {
    if let productId = productId {
      if !MyInfo.sharedMyInfo().isUser() {
        ViewControllerHelper.topRootViewController()?.showSigningView()
      } else {
        NetworkHelper.requestPost(requestUrl(),
                                  parameter: requestParameter(productId),
                                  success: { (result) in
                                    saveFavoriteProduct(productId)
                                    success()
      })
      }
    }
  }
  
  static func deleteFavoriteProduct(productId: Int?, success: () -> Void) {
    if let productId = productId {
      NetworkHelper.requestDelete(requestUrl(),
                                parameter: requestParameter(productId),
                                success: { (result) in
                                  removeFavoriteProduct(productId)
                                  success()
      })
    }
  }
  
  static func saveFavoriteProduct(productId:Int?) {
    if let productId = productId,
    var favoriteProductIds = NSUserDefaults.standardUserDefaults().objectForKey(kFavoriteProductIds) as? [Int] {
      favoriteProductIds.appendObject(productId)
      NSUserDefaults.standardUserDefaults().setObject(favoriteProductIds, forKey: kFavoriteProductIds)
    } else {
      let favoriteProductIds = [productId!]
      NSUserDefaults.standardUserDefaults().setObject(favoriteProductIds, forKey: kFavoriteProductIds)
    }
  }
  
  static func removeFavoriteProduct(productId:Int?) {
    if var favoriteProductIds = NSUserDefaults.standardUserDefaults().objectForKey(kFavoriteProductIds) as? [Int] {
      favoriteProductIds.removeObject(productId)
      NSUserDefaults.standardUserDefaults().setObject(favoriteProductIds, forKey: kFavoriteProductIds)
    }
  }
  
  static func resetFavoriteProduct() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(kFavoriteProductIds)
  }
}

extension FavoriteProductHelper {
  static private func requestUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/favorite-products"
    }
    return "favorite-products"
  }
  
  static private func requestParameter(productId: Int) -> [String: Int] {
    var pararmeter = [String: Int]()
    pararmeter["productId"] = productId
    return pararmeter
  }
}
