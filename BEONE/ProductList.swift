
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
  var noData = false
  
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
    switch type {
    case .Shop:
      return nil
    case .None:
      var parameter = [String: AnyObject]()
      parameter["locationId"] = BEONEManager.selectedLocation?.id
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
    print(data)
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
