
import UIKit

class Products: BaseListModel {
  
  enum Type {
    case None
    case Shop
    case Category
    case Recent
    case Favorite
  }
  
  var type = Type.None
  var productPropertyValueIds: [Int]?
  var tagIds: [Int]?
  var availableDates: [String]?
  var minPrice: Int?
  var maxPrice: Int?
  var shopId: Int?
  var address: Address?
  var productCategoryId: Int?
  lazy var locationId: Int? = {
    return BEONEManager.selectedLocation?.id
  }()
  var noData = false
  var isQuickOrder = false
  
  override func getUrl() -> String {
    switch type {
    case .Shop:
      if let shopId = shopId {
        return "shops/\(shopId)/products"
      }
    case .Category:
      if let productCategoryId = productCategoryId {
        return "product-categories/\(productCategoryId)/products"
      }
    case .Recent:
      return "recent-products"
    case .Favorite:
      if MyInfo.sharedMyInfo().isUser() {
        return "users/\(MyInfo.sharedMyInfo().userId!)/favorite-products"
      }
      return "favorite-products"
    case .None:
      return "products"
    }
    return "products"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter[kNetworkRequestKeyLocationId] = locationId
    switch type {
    case .Shop, .Category, .Recent:
      return nil
    case .Favorite:
//      parameter["noData"] = noData
      return nil
    case .None:
      parameter["productPropertyValueIds"] = productPropertyValueIds
      parameter["tagIds"] = tagIds
      parameter["minPrice"] = minPrice
      parameter["maxPrice"] = maxPrice
      parameter["noData"] = noData
      parameter["isQuickOrder"] = isQuickOrder
      parameter["availableDates"] = availableDates
      parameter["address"] = address?.addressString()
      parameter["addressType"] = address?.addressType?.rawValue
    }
    return parameter
  }
  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if type == .Favorite {
      FavoriteProductHelper.resetFavoriteProduct()
    }
    if let products = data as? [[String: AnyObject]] {
      for productObject in products {
        let product = Product()
        product.assignObject(productObject)
        list.appendObject(product)
        if type == .Favorite {
          FavoriteProductHelper.saveFavoriteProduct(product.id)
        }
      }
    }
  }
}
