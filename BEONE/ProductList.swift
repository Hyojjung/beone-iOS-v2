
import UIKit

class ProductList: BaseListModel {
  enum Type {
    case None
    case Shop
  }
  
  var type = Type.None
  var productPropertyValueIds: [Int]?
  var tagIds: [Int]?
  var minPrice: Int?
  var maxPrice: Int?
  
  override func fetchUrl() -> String {
    switch type {
    case .Shop:
      if let shopId = BEONEManager.selectedShop?.id {
        return "shops/\(shopId)/products"
      } else {
        return "products"
      }
    case .None:
      return "products"
    }
  }
  
  override func fetchParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["locationId"] = BEONEManager.selectedLocation?.id
    parameter["productPropertyValueIds"] = productPropertyValueIds
    parameter["tagIds"] = tagIds
    parameter["minPrice"] = minPrice
    parameter["maxPrice"] = maxPrice
    return parameter
  }
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let productList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for productObject in productList {
        let product = Product()
        product.assignObject(productObject)
        list.append(product)
      }
      postNotification(kNotificationFetchProductListSuccess)
    }
  }
}
