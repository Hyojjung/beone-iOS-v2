
import UIKit

class Advertisement: BaseModel {
  
  let action = Action()
  var imageUrl: String?
  
  override func getUrl() -> String {
    return "advertisements/front"
  }
  
  override func assignObject(data: AnyObject?) {
    if let advertisement = data as? [String: AnyObject] {
      id = advertisement[kObjectPropertyKeyId] as? Int
      action.assignObject(advertisement["action"])
      imageUrl = advertisement["imageUrl"] as? String
    }
  }
}
