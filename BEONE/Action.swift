
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
}

class Action: BaseModel {
  var type: ActionType?
  var content: String?
  // url string for webview
  // scheme string for scheme
  // alert message fot alert
  
  var hasCancel: Bool?
  var confirmationAction: Action?
  var cancelAction: Action?
  
  // MARK: - Override Methods
  
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
  
  func action() {
    if let type = type {
      switch type {
      case .Webview:
        ViewControllerHelper.showWebView(content, title: nil)
      case .Scheme:
        print("scheme")
      case .Alert:
        if let content = content {
          var userInfo = [String: AnyObject]()
          userInfo[kNotificationAlertKeyMessage] = content
          userInfo[kNotificationAlertKeyHasCancel] = hasCancel
          userInfo[kNotificationAlertKeyConfirmationAction] = confirmationAction
          userInfo[kNotificationAlertKeyCancelAction] = cancelAction
          NSNotificationCenter.defaultCenter().postNotificationName(kNotificationShowAlert, object: nil, userInfo: userInfo)
        }
      default:
        break
      }
    }
  }
}
