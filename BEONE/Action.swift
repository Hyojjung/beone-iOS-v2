
import UIKit

let kActionKeyType = "type"
let kActionKeyContent = "content"
let kActionKeyHasCancel = "hasCancel"
let kActionKeyConfirmationAction = "confirmationAction"
let kActionKeyCancelAction = "cancelAction"

enum ActionType: String {
  case None = "none"
  case Webview = "webview"
  case Scheme = "scheme"
  case Alert = "alert"
  case Method = "method"
}

class Action: BaseModel {
  
  // MARK: - Property

  var type: ActionType?
  var content: String?
  // url string for webview
  // scheme string for scheme
  // alert message fot alert
  
  var hasCancel: Bool?
  var confirmationAction: Action?
  var cancelAction: Action?
  var actionDelegate: AnyObject?

  // MARK: - BaseModel Methods
  
  override func assignObject(data: AnyObject) {
    if let action = data as? [String: AnyObject] {
      if let type = action[kActionKeyType] as? String {
        self.type = ActionType(rawValue: type)
      }
      content = action[kActionKeyContent] as? String
      hasCancel = action[kActionKeyHasCancel] as? Bool
      if let confirmationAction = action[kActionKeyConfirmationAction] {
        self.confirmationAction = Action()
        self.confirmationAction!.assignObject(confirmationAction)
      }
      if let cancelAction = action[kActionKeyCancelAction] {
        self.cancelAction = Action()
        self.cancelAction!.assignObject(cancelAction)
      }
    }
  }
}

// MARK: - Private Methods

extension Action {
  func action() {
    if let type = type, content = content {
      switch type {
      case .Webview:
        var userInfo = [String: AnyObject]()
        userInfo[kNotificationAlertKeyMessage] = content
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationShowWebView, object: nil, userInfo: userInfo)
      case .Scheme:
        print("scheme")
      case .Alert:
        var userInfo = [String: AnyObject]()
        userInfo[kNotificationAlertKeyMessage] = content
        userInfo[kNotificationAlertKeyHasCancel] = hasCancel
        userInfo[kNotificationAlertKeyConfirmationAction] = confirmationAction
        userInfo[kNotificationAlertKeyCancelAction] = cancelAction
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationShowAlert, object: nil, userInfo: userInfo)
      case .Method:
        actionDelegate?.performSelector(Selector(stringLiteral: content))
      default:
        break
      }
    }
  }
}