
import UIKit

class Tags: BaseListModel {
  
  var name: String?
  var desc: String?
  
  override func getUrl() -> String {
    return "tag-groups/filter"
  }
  
  override func assignObject(data: AnyObject?) {
    if let tagGroup = data as? [String: AnyObject] {
      name = tagGroup[kObjectPropertyKeyName] as? String
      desc = tagGroup[kObjectPropertyKeyDescription] as? String
      if let tagObjects = tagGroup["tags"] as? [[String: AnyObject]] {
        list.removeAll()
        for tagObject in tagObjects {
          let tag = Tag()
          tag.assignObject(tagObject)
          list.appendObject(tag)
        }
      }
    }
  }
}
