
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
let kProductCoupleTemplateCellIdentifier = "productCoupleTemplateCell"
let kProductSingleTemplateCellIdentifier = "productSingleTemplateCell"

enum TemplateType: String {
  case Text = "text"
  case Image = "image"
  case Button = "button"
  case Shop = "shop"
  case ProductCouple = "productCouple"
  case ProductSingle = "productSingle"
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
    case .ProductCouple:
      return kProductCoupleTemplateCellIdentifier
    case .ProductSingle:
      return kProductSingleTemplateCellIdentifier
    default:
      fatalError("no cell identifier with template type")
    }
  }
}

class Template: BaseModel {
  var type: TemplateType?
  
  var style = TemplateStyle()
  var content = Content()
  
  var height: CGFloat?
  
  // MARK: - Override Methods
  
  init(type: TemplateType) {
    super.init()
    self.type = type
    if type == .ProductCouple || type == .ProductSingle {
      content.models = [Product]()
    }
  }
  
  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      id = template[kObjectPropertyKeyId] as? Int
      if let style = template[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
        self.style.assignObject(style)
      }
      if let contentObject = template[kTemplatePropertyKeyContents] as? [String: AnyObject] {
        content.assignObject(contentObject)
      }
    }
  }
}