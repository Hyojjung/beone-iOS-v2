
import UIKit

let kTemplatePropertyKeyType = "type"
let kTemplatePropertyKeyStyle = "style"
let kTemplatePropertyKeyHasSpace = "hasSpace"
let kTemplatePropertyKeyRow = "row"
let kTemplatePropertyKeyColumn = "col"
let kTemplatePropertyKeyCount = "count"
let kTemplatePropertyKeyContents = "contents"
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
  var contents = [Contents]()
  
  var hasSpace: Bool?
  var row: Int?
  var column: Int?
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
      hasSpace = template[kTemplatePropertyKeyHasSpace] as? Bool
      row = template[kTemplatePropertyKeyRow] as? Int
      column = template[kTemplatePropertyKeyColumn] as? Int
      count = template[kTemplatePropertyKeyCount] as? Int
      if let style = template[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
        self.style.assignObject(style)
      }
      if let contents = template[kTemplatePropertyKeyContents] as? [[String: AnyObject]] { // something else
        for contentObject in contents {
          let content = Contents()
          content.assignObject(contentObject)
          self.contents.append(content)
        }
      }
    }
  }
}