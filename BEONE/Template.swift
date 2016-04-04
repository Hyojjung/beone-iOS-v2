
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
let kReviewsTemplateCellIdentifier = "reviewsTemplateCell"
let kBannerTemplateCellIdentifier = "bannerTemplateCell"
let kShopTemplateCellIdentifier = "shopTemplateCell"

enum TemplateType: String {
  case Text = "text"
  case Image = "image"
  case Button = "button"
  case Shop = "shop"
  case ProductCouple = "productCouple"
  case ProductSingle = "productSingle"
  case Review = "review"
  case Banner = "banner"
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
    case .Review:
      return kReviewsTemplateCellIdentifier
    case .Banner:
        return kBannerTemplateCellIdentifier
    case .Shop:
      return kShopTemplateCellIdentifier
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
    content.type = type
  }
  
  override func assignObject(data: AnyObject?) {
    if let template = data as? [String: AnyObject] {
      print(data)
      id = template[kObjectPropertyKeyId] as? Int
      style.assignObject(template[kTemplatePropertyKeyStyle])
      content.assignObject(template[kTemplatePropertyKeyContents])
    }
  }
}