
import UIKit

class Notice: BaseModel {
  
  var title: String?
  var createdAt: NSDate?
  var targetUrl: String?
  
  override func assignObject(data: AnyObject) {
    if let notice = data as? [String: AnyObject] {
      id = notice[kObjectPropertyKeyId] as? Int
      title = notice["title"] as? String
      targetUrl = notice["targetUrl"] as? String
      if let createdAt = notice["createdAt"] as? String {
        self.createdAt = createdAt.date()
      }
    }
  }
}
