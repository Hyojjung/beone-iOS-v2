
import UIKit

class Templates: BaseListModel {
  var filterdTemplates = [Template]()
  
  override func assignObject(data: AnyObject?) {
    list.removeAll()
    if let templates = data as? [[String: AnyObject]] {
      for templateObject in templates {
        if let type = templateObject[kTemplatePropertyKeyType] as? String, templateType = TemplateType(rawValue: type) {
          let template = Template(type: templateType)
          template.assignObject(templateObject)
          list.appendObject(template)
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
            newTmplate.content.models = [Product]()
            newTmplate.content.models?.appendObject(product)
            if index < (template.content.models?.count)! - 1 {
              newTmplate.content.models?.appendObject(template.content.models![index + 1] as! Product)
            }
            filterdTemplates.appendObject(newTmplate)
          }
        }
      } else if template.type == .ProductSingle {
        for product in template.content.models as! [Product] {
          let newTmplate = Template(type: .ProductSingle)
          newTmplate.content.models = [Product]()
          newTmplate.content.models?.appendObject(product)
          filterdTemplates.appendObject(newTmplate)
        }
      } else if template.type == .Shop {
        for shop in template.content.models as! [Shop] {
          let newTmplate = Template(type: .Shop)
          newTmplate.content.models = [Shop]()
          newTmplate.content.models?.appendObject(shop)
          filterdTemplates.appendObject(newTmplate)
        }
      } else {
        filterdTemplates.appendObject(template)
      }
    }
  }
  
  override func getUrl() -> String {
    return "app-views/main/template-items"
  }
}
