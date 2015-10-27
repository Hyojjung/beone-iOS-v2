//
//  SnsSignUpViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SnsSignUpViewController: BaseViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet var agreementButtons: [UIButton]!
  @IBOutlet weak var allAgreementButton: UIButton!
  
  // MARK: - View Cycles
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController!.navigationBar.hidden = true
  }
  
  // MARK: - Override Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "setUpTextField:",
      name: kNotificationFetchFacebookInfoSuccess,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "closeViewController",
      name: kNotificationSigningSuccess,
      object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func setUpView() {
    AuthenticationHelper.getFaceBookInfo()
    emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  // MARK: - Actions
  
  @IBAction func backButtonTapped() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func snsSignUpButtonTapped() {
    if let errorMessage = errorMessage() {
      ViewControllerHelper.showAlertView(errorMessage, message: nil)
    } else {
      AuthenticationHelper.signUp(SnsType.Facebook,
        userId: FBSDKAccessToken.currentAccessToken().userID,
        token: FBSDKAccessToken.currentAccessToken().tokenString,
        email: emailTextField.text!,
        name: nameTextField.text!)
    }
  }
  
  @IBAction func agreementButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    var isAllAgreed = true
    for agreementButton in agreementButtons {
      isAllAgreed = !agreementButton.selected ? false : isAllAgreed
    }
    allAgreementButton.selected = isAllAgreed
  }
  
  @IBAction func allAgreementTapped(sender: UIButton) {
    sender.selected = !sender.selected
    for agreementButton in agreementButtons {
      agreementButton.selected = sender.selected
    }
  }
  
  // MARK: - Observer Actions
  
  func setUpTextField(notification: NSNotification) {
    if let userInfo = notification.userInfo as? [String: String] {
      emailTextField.text = userInfo[kNotificationKeyFacebookEmail]
      nameTextField.text = userInfo[kNotificationKeyFacebookName]
    }
  }
  
  func closeViewController() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Private Methods
  
  private func errorMessage() -> String? {
    if emailTextField.text == nil || !emailTextField.text!.isValidEmail() {
      return NSLocalizedString("check email form", comment: "alert")
    } else if nameTextField.text == nil || nameTextField.text!.isEmpty {
      return NSLocalizedString("enter name", comment: "alert")
    }
    for agreementButton in agreementButtons {
      if !agreementButton.selected {
        return NSLocalizedString("need agreement all rule", comment: "alert")
      }
    }
    return nil
  }
  // TODO: - floating text field, webview 연결
}

// MARK: - UITextFieldDelegate

extension SnsSignUpViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      nameTextField.becomeFirstResponder()
    } else if textField == nameTextField {
      view.endEditing(true)
    }
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    textField.text = textField.text?.emailCharacterString()
  }
}