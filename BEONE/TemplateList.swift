
import UIKit

class TemplateList: BaseListModel {
  override func assignObject(data: AnyObject) {
    if let templateList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for templateObject in templateList {
        let template = Template()
        template.assignObject(templateObject)
        list.append(template)
      }
    }
  }
}
