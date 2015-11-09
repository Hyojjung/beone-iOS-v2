//
//  PasswordFindingViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 9..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class PasswordFindingViewController: BaseViewController {
  
  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!

  @IBAction func passwordFindButtonTapped() {
    view.endEditing(true)
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage, hasCancel: false, confirmAction: nil, cancelAction: nil)
    } else if let email = emailTextField.text {
      SigningHelper.requestFindingPassword(email)
    }
  }

  @IBAction func backButtonTapped() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func setUpView() {
    ViewControllerHelper.setUpFloatingLabel(emailTextField, placeholder: NSLocalizedString("email form", comment: "email form"))
    emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSuccess", name: kNotificationRequestFindingPasswordSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleFailure:", name: kNotificationRequestFindingPasswordFailure, object: nil)
  }
  
  // MARK: - Private Methods
  
  private func errorMessage() -> String? {
    if emailTextField.text == nil || !emailTextField.text!.isValidEmail() {
      return NSLocalizedString("check email form", comment: "alert")
    }
    return nil
  }
  
  // MARK: - Noti Actions
  
  func handleSuccess() {
    let popAction = Action()
    popAction.type = .Method
    popAction.content = "popView"
    showAlertView(NSLocalizedString("email sended", comment: "email sended"), hasCancel: false, confirmAction: popAction, cancelAction: nil)
  }
  
  func handleFailure(notification: NSNotification) {
    if let userInfo = notification.userInfo, statusCode = userInfo[kNotificationKeyErrorStatusCode] as? Int {
      switch statusCode {
      case NetworkResponseCode.NotFound.rawValue:
        showAlertView(NSLocalizedString("email not found", comment: "alert"), hasCancel: false, confirmAction: nil, cancelAction: nil)
      default:
        break
      }
    }
  }
}

extension PasswordFindingViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordFindButtonTapped()
    }
    return true
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    scrollView.focusOffset = textField.frame.origin.y - emailTextField.frame.origin.y
    
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    textField.text = textField.text?.emailCharacterString()
  }
}