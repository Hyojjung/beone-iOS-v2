
import UIKit

class TemplateList: BaseListModel {
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let templateList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for templateObject in templateList {
        if let type = templateObject[kTemplatePropertyKeyType] as? String, templateType = TemplateType(rawValue: type) {
          let template = Template(type: templateType)
          template.assignObject(templateObject)
          list.append(template)
        }
      }
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchTemplateListSuccess, object: nil)
    }
  }
  
  override func fetchUrl() -> String {
    return "app-views/main/template-items"
  }
}
