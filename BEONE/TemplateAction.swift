//
//  TemplateAction.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 30..
//  Copyright © 2015년 효정 김. All rights reserved.
//

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
      case .None:
        print("none")
      case .Webview:
        ViewControllerHelper.showWebView(content, title: nil)
      case .Scheme:
        print("scheme")
      case .Alert:
        print("alert")
      }
    }
  }
}
