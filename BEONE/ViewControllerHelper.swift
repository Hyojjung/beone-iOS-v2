//
//  ViewControllerHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

struct ActionSheetButton {
  let title: String
  let action: UIAlertAction -> Void
}

class ViewControllerHelper: NSObject {
  static func showActionSheet(viewController: UIViewController, title: String?, actionSheetButtons: [ActionSheetButton]) {
      let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
      
      for actionSheetButton in actionSheetButtons {
        let button = UIAlertAction(title: actionSheetButton.title, style: .Default, handler: actionSheetButton.action)
        actionSheet.addAction(button)
      }
      
      let cancelButton = UIAlertAction(title: "취소", style: .Cancel, handler:nil)
      actionSheet.addAction(cancelButton)
      
      viewController.presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  static func showAlertView(title: String, message: String?) {
    let alertView =
    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "취소")
    alertView.addButtonWithTitle(NSLocalizedString("ok", comment: "okButtonTitle"))
    alertView.show()
  }
}
