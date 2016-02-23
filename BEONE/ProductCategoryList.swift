
import UIKit

class ProductCategoryList: BaseListModel {
  override func getUrl() -> String {
    return "product-categories"
  }
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [[String: AnyObject]] {
      list.removeAll()
      for categoryObject in data {
        let productCategory = ProductCategory()
        productCategory.assignObject(categoryObject)
        list.append(productCategory)
      }
    }
  }
}
