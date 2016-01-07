
import UIKit

let kTemplatePropertyKeyType = "type"
let kTemplatePropertyKeyStyle = "style"
let kTemplatePropertyKeyCount = "count"
let kTemplatePropertyKeyContents = "content"
let kTemplatePropertyKeyTemplateItems = "templateItems"

let kTextTemplateCellIdentifier = "textTemplateCell"
let kImageTemplateCellIdentifier = "imageTemplateCell"
let kButtonTemplateCellIdentifier = "buttonTemplateCell"
let kTableTemplateCellIdentifier = "tableTemplateCell"

enum TemplateType: String {
  case Text = "text"
  case Image = "image"
  case Button = "button"
  case Shop = "shop"
  case Product
  case Review
  case Banner
  case Table = "table"
  
  func cellIdentifier() -> String {
    switch(self) {
    case .Text:
      return kTextTemplateCellIdentifier
    case .Image:
      return kImageTemplateCellIdentifier
    case .Button:
      return kButtonTemplateCellIdentifier
    case .Table:
      return kTableTemplateCellIdentifier
    default:
      fatalError("no cell identifier with template type")
    }
  }
}

class Template: BaseModel {
  var type: TemplateType?
  
  var style = TemplateStyle()
  var content = Content()
  
  var count: Int?
  
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