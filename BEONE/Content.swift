
import UIKit

let kContentsPropertyKeyBackgroundColor = "backgroundColor"
let kContentsPropertyKeyPressedTextColor = "pressedTextColor"
let kContentsPropertyKeyTextColor = "textColor"
let kContentsPropertyKeyAlignment = "alignment"
let kContentsPropertyKeyText = "text"
let kContentsPropertyKeyIsUnderlined = "isUnderlined"
let kContentsPropertyKeyIsBold = "isBold"
let kContentsPropertyKeyIsItalic = "isItalic"
let kContentsPropertyKeyIsCancelLined = "isCancelLined"
let kContentsPropertyKeySize = "size"
let kContentsPropertyKeyTextSize = "textSize"
let kContentsPropertyKeyImageUrl = "imageUrl"
let kContentsPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
let kContentsPropertyKeyPressedBackgroundImageUrl = "pressedBackgroundImageUrl"
let kContentsPropertyKeyPressedBackgroundColor = "pressedBackgroundColor"
let kContentsPropertyKeyBorderColor = "borderColor"
let kContentsPropertyKeyAction = "action"
let kContentsPropertyKeyHasSpace = "hasSpace"
let kContentsPropertyKeyRow = "row"
let kContentsPropertyKeyColumn = "col"

enum Alignment: String {
  case Left = "left"
  case Center = "center"
  case Right = "right"
}

class Content: BaseModel {
  var action = Action()
  var type: TemplateType?

  lazy var items: [Content] = {
    return [Content]()
  }()
  var hasSpace: Bool?
  var row: Int?
  var column: Int?
  
  var text: String?
  var alignment: Alignment?
  var isUnderlined: Bool?
  var isBold: Bool?
  var isItalic: Bool?
  var isCancelLined: Bool?
  var backgroundColor: UIColor?
  var textColor: UIColor?
  var pressedTextColor: UIColor?
  var pressedBackgroundColor: UIColor?
  var borderColor: UIColor?
  var size: CGFloat?
  var textSize: CGFloat?
  var imageUrl: String?
  var backgroundImageUrl: String?
  var pressedBackgroundImageUrl: String?
  var padding = UIEdgeInsetsZero
  var models: [BaseModel]?
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject?) {
    if let contents = data as? [String: AnyObject] {
      id = contents[kObjectPropertyKeyId] as? Int
      text = contents[kContentsPropertyKeyText] as? String
      imageUrl = contents[kContentsPropertyKeyImageUrl] as? String
      backgroundImageUrl = contents[kContentsPropertyKeyBackgroundImageUrl] as? String
      pressedBackgroundImageUrl = contents[kContentsPropertyKeyPressedBackgroundImageUrl] as? String
      isUnderlined = contents[kContentsPropertyKeyIsUnderlined] as? Bool
      isBold = contents[kContentsPropertyKeyIsBold] as? Bool
      isItalic = contents[kContentsPropertyKeyIsItalic] as? Bool
      isCancelLined = contents[kContentsPropertyKeyIsCancelLined] as? Bool
      size = contents[kContentsPropertyKeySize] as? CGFloat
      textSize = contents[kContentsPropertyKeyTextSize] as? CGFloat
      hasSpace = contents[kContentsPropertyKeyHasSpace] as? Bool
      row = contents[kContentsPropertyKeyRow] as? Int
      column = contents[kContentsPropertyKeyColumn] as? Int
      
      if let borderColor = contents[kContentsPropertyKeyBorderColor] as? String {
        self.borderColor = UIColor(rgba: borderColor)
      }
      if let backgroundColor = contents[kContentsPropertyKeyBackgroundColor] as? String {
        self.backgroundColor = UIColor(rgba: backgroundColor)
      }
      if let pressedBackgroundColor = contents[kContentsPropertyKeyPressedBackgroundColor] as? String {
        self.pressedBackgroundColor = UIColor(rgba: pressedBackgroundColor)
      }
      if let textColor = contents[kContentsPropertyKeyTextColor] as? String {
        self.textColor = UIColor(rgba: textColor)
      }
      if let pressedTextColor = contents[kContentsPropertyKeyPressedTextColor] as? String {
        self.pressedTextColor = UIColor(rgba: pressedTextColor)
      }
      if let alignment = contents[kContentsPropertyKeyAlignment] as? String {
        self.alignment = Alignment(rawValue: alignment)
      }
      self.action.assignObject(contents[kContentsPropertyKeyAction])
      
      if let padding = contents[kTemplateStylePropertyKeyPadding] as? String {
        self.padding = padding.edgeInsets()
      }
      
      if let itemsObject = contents["items"] as? [[String: AnyObject]] {
        if type == .ProductCouple || type == .ProductSingle {
          models = [Product]()
          for itemObject in itemsObject {
            let product = Product()
            product.assignObject(itemObject)
            models?.appendObject(product)
          }
        } else if type == .Review {
          models = [Review]()
          for itemObject in itemsObject {
            let review = Review()
            review.assignObject(itemObject)
            models?.appendObject(review)
          }
        } else {
          items.removeAll()
          for itemObject in itemsObject {
            let item = Content()
            item.assignObject(itemObject)
            items.appendObject(item)
          }
        }
      }
      
    }
  }
}
