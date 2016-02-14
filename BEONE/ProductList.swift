
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
  var shopId: Int?
  lazy var locationId: Int? = {
    return BEONEManager.selectedLocation?.id
  }()
  var noData = false
  
  override func getUrl() -> String {
    switch type {
    case .Shop:
      if let shopId = shopId {
        return "shops/\(shopId)/products"
      } else {
        return "products"
      }
    case .None:
      return "products"
    }
  }
  
  override func getParameter() -> AnyObject? {
    switch type {
    case .Shop:
      return nil
    case .None:
      var parameter = [String: AnyObject]()
      parameter["locationId"] = locationId
      parameter["productPropertyValueIds"] = productPropertyValueIds
      parameter["tagIds"] = tagIds
      parameter["minPrice"] = minPrice
      parameter["maxPrice"] = maxPrice
      parameter["noData"] = noData
      return parameter
    }
  }
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let productList = data as? [[String: AnyObject]] {
      for productObject in productList {
        let product = Product()
        product.assignObject(productObject)
        list.append(product)
      }
    }
    if let total = data["total"] as? Int{
      self.total = total
    }
  }
}
