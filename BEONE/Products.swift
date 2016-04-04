
import UIKit

class Products: BaseListModel {
  
  enum Type {
    case None
    case Shop
    case Category
    case Recent
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
    case .None:
      return "products"
    }
    return "products"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["locationId"] = locationId
    switch type {
    case .Shop, .Category, .Recent:
      return nil
    case .None:
      parameter["productPropertyValueIds"] = productPropertyValueIds
      parameter["tagIds"] = tagIds
      parameter["minPrice"] = minPrice
      parameter["maxPrice"] = maxPrice
      parameter["noData"] = noData
      parameter["availableDates"] = availableDates
      parameter["address"] = address?.addressString()
      parameter["addressType"] = address?.addressType?.rawValue
    }
    return parameter
  }
  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let products = data as? [[String: AnyObject]] {
      for productObject in products {
        let product = Product()
        product.assignObject(productObject)
        list.appendObject(product)
      }
    }
  }
}
