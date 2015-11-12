
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
let kContentsPropertyKeyImageUrl = "imageUrl"
let kContentsPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
let kContentsPropertyKeyPressedBackgroundImageUrl = "pressedBackgroundImageUrl"
let kContentsPropertyKeyPressedBackgroundColor = "pressedBackgroundColor"
let kContentsPropertyKeyBorderColor = "borderColor"
let kContentsPropertyKeyAction = "action"

enum Alignment: String {
  case Left = "left"
  case Center = "center"
  case Right = "right"
}

class Contents: BaseModel {
  var action = Action()
  
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
  var imageUrl: String?
  var backgroundImageUrl: String?
  var pressedBackgroundImageUrl: String?
  var model: BaseModel?
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let contents = data as? [String: AnyObject] {
      // TODO: - Assign Model
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
      if let action = contents[kContentsPropertyKeyAction] {
        self.action.assignObject(action)
      }
    }
  }
}
