
import UIKit

let kActionPropertyKeyType = "type"
let kActionPropertyKeyContent = "content"
let kActionPropertyKeyHasCancel = "hasCancel"
let kActionPropertyKeyConfirmationAction = "confirmAction"
let kActionPropertyKeyCancelAction = "cancelAction"

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
  
  override func assignObject(data: AnyObject?) {
    if let action = data as? [String: AnyObject] {
      if let type = action[kActionPropertyKeyType] as? String {
        self.type = ActionType(rawValue: type)
      }
      content = action[kActionPropertyKeyContent] as? String
      hasCancel = action[kActionPropertyKeyHasCancel] as? Bool
      if let confirmationAction = action[kActionPropertyKeyConfirmationAction] {
        self.confirmationAction = Action()
        self.confirmationAction!.assignObject(confirmationAction)
      }
      if let cancelAction = action[kActionPropertyKeyCancelAction] {
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
        postNotification(kNotificationShowWebView, userInfo: userInfo)
      case .Scheme:
        SchemeHelper.setUpScheme(content)
      case .Alert:
        var userInfo = [String: AnyObject]()
        userInfo[kNotificationAlertKeyMessage] = content
        userInfo[kNotificationAlertKeyHasCancel] = hasCancel
        userInfo[kNotificationAlertKeyConfirmationAction] = confirmationAction
        userInfo[kNotificationAlertKeyCancelAction] = cancelAction
//        postNotification(kNotificationShowAlert, userInfo: userInfo)
        if let revealViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? SWRevealViewController,
          navigationViewController = revealViewController.frontViewController as? UINavigationController {
          navigationViewController.showAlertView(content,
                        hasCancel: hasCancel,
                        confirmAction: confirmationAction,
                        cancelAction: cancelAction,
                        delegate: navigationViewController)
        }
      case .Method:
        actionDelegate?.performSelector(Selector(stringLiteral: content))
      default:
        break
      }
    }
  }
}