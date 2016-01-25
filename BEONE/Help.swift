
import UIKit

class Help: BaseModel {

  var title: String?
  var targetUrl: String?
  
  override func assignObject(data: AnyObject) {
    if let notice = data as? [String: AnyObject] {
      id = notice[kObjectPropertyKeyId] as? Int
      title = notice["title"] as? String
      targetUrl = notice["targetUrl"] as? String
    }
  }
}
