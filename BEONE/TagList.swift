
import UIKit

class TagList: BaseListModel {
  
  var name: String?
  var subTitle: String?
  
  override func fetchUrl() -> String {
    return "tag-groups/filter"
  }
  
  override func assignObject(data: AnyObject) {
    if let tagGroup = data[kNetworkResponseKeyData] as? [String: AnyObject] {
      name = tagGroup["name"] as? String
      subTitle = tagGroup["description"] as? String
      if let tagObjects = tagGroup["tags"] as? [[String: AnyObject]] {
        list.removeAll()
        for tagObject in tagObjects {
          let tag = Tag()
          tag.assignObject(tagObject)
          list.append(tag)
        }
      }
    }
  }
}
