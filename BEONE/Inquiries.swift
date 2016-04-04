
import UIKit

class Inquiries: BaseListModel {
  
  var productId: Int?
  
  override func getUrl() -> String {
    if let productId = productId {
      return "products/\(productId)/inquiries"
    }
    return "inquiries"
  }
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [[String: AnyObject]] {
      list.removeAll()
      for inquiryObject in data {
        let inquiry = Inquiry()
        inquiry.assignObject(inquiryObject)
        list.appendObject(inquiry)
      }
    }
  }
}
