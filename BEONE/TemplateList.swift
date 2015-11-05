
import UIKit

class TemplateList: BaseListModel {
  override func assignObject(data: AnyObject) {
    if let templateList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for templateObject in templateList {
        let template = Template()
        template.assignObject(templateObject)
        list.append(template)
      }
      NSNotificationCenter.defaultCenter().postNotificationName("success", object: nil)
    }
  }
  
  override func fetchUrl() -> String {
    return "app-views/main/template-items"
  }
  
}
