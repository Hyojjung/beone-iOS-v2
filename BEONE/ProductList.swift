
import UIKit

class ProductList: BaseListModel {
  
  enum Type {
    case None
    case Shop
    case Category
  }
  
  var type = Type.None
  var productPropertyValueIds: [Int]?
  var tagIds: [Int]?
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
    case .None:
      return "products"
    }
    return "products"
  }
  
  override func getParameter() -> AnyObject? {
    switch type {
    case .Shop, .Category:
      return nil
    case .None:
      var parameter = [String: AnyObject]()
      parameter["locationId"] = locationId
      parameter["productPropertyValueIds"] = productPropertyValueIds
      parameter["tagIds"] = tagIds
      parameter["minPrice"] = minPrice
      parameter["maxPrice"] = maxPrice
      parameter["noData"] = noData
      parameter["address"] = address?.addressString()
      parameter["addressType"] = address?.addressType?.rawValue
      print(parameter)
      return parameter
    }
  }
  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let productList = data as? [[String: AnyObject]] {
      for productObject in productList {
        let product = Product()
        product.assignObject(productObject)
        list.appendObject(product)
      }
    }
  }
}
