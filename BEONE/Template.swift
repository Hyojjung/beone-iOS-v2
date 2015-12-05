
import UIKit

let kTemplatePropertyKeyType = "type"
let kTemplatePropertyKeyStyle = "style"
let kTemplatePropertyKeyCount = "count"
let kTemplatePropertyKeyContents = "content"
let kTemplatePropertyKeyTemplateItems = "templateItems"

enum TemplateType: String {
  case Text = "text"
  case Image = "image"
  case Button = "button"
  case Gap
  case Shop = "shop"
  case Product
  case Review
  case Banner
  case Table = "table"
}

class Template: BaseModel {
  var type: TemplateType?
  
  var style = TemplateStyle()
  var content = Content()
  
  var count: Int?
  var height: CGFloat?
  
  // MARK: - Override Methods
  
  init(type: TemplateType) {
    super.init()
    self.type = type
  }
  
  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      id = template[kObjectPropertyKeyId] as? Int
      count = template[kTemplatePropertyKeyCount] as? Int
      if let style = template[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
        self.style.assignObject(style)
      }
      if let contentObject = template[kTemplatePropertyKeyContents] as? [String: AnyObject] {
        content.assignObject(contentObject)
      }
    }
  }
}