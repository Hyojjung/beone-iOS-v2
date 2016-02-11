
import UIKit

class TemplateList: BaseListModel {
  var filterdTemplates = [Template]()
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let templateList = data as? [[String: AnyObject]] {
      for templateObject in templateList {
        if let type = templateObject[kTemplatePropertyKeyType] as? String, templateType = TemplateType(rawValue: type) {
          let template = Template(type: templateType)
          template.assignObject(templateObject)
          list.append(template)
        }
      }
    }
    filterTemplates()
  }
  
  func filterTemplates() {
    filterdTemplates.removeAll()
    for template in list as! [Template] {
      if template.type == .ProductCouple {
        for (index, product) in (template.content.models as! [Product]).enumerate() {
          if index % 2 == 0 {
            let newTmplate = Template(type: .ProductCouple)
            newTmplate.content.models?.append(product)
            if index < (template.content.models?.count)! - 1 {
              newTmplate.content.models?.append(template.content.models![index + 1] as! Product)
            }
            filterdTemplates.append(newTmplate)
          }
        }
      } else if template.type == .ProductSingle {
        for product in template.content.models as! [Product] {
          let newTmplate = Template(type: .ProductSingle)
          newTmplate.content.models?.append(product)
          filterdTemplates.append(newTmplate)
        }
      } else {
        filterdTemplates.append(template)
      }
    }
  }
  
  override func getUrl() -> String {
    return "app-views/main/template-items"
  }
}
