//
//  SignUpViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
  
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!
  @IBOutlet weak var nameTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordVerifyingTextField: UIFloatLabelTextField!
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
      selector: "closeViewController",
      name: kNotificationSigningSuccess,
      object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func setUpView() {
    ViewControllerHelper.setUpFloatingLabel(emailTextField,
      placeholder: NSLocalizedString("email form", comment: "placeholder"))
    ViewControllerHelper.setUpFloatingLabel(nameTextField,
      placeholder: NSLocalizedString("name form", comment: "placeholder"))
    ViewControllerHelper.setUpFloatingLabel(passwordTextField,
      placeholder: NSLocalizedString("password form", comment: "placeholder"))
    ViewControllerHelper.setUpFloatingLabel(passwordVerifyingTextField,
      placeholder: NSLocalizedString("password form", comment: "placeholder"))
    
    emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    passwordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    passwordVerifyingTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  // MARK: - Actions
  
  @IBAction func backButtonTapped() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func signUpButtonTapped() {
    if let errorMessage = errorMessage() {
      ViewControllerHelper.showAlertView(errorMessage, hasCancel: false, confirmAction: nil, cancelAction: nil)
    } else {
      AuthenticationHelper.signUp(emailTextField.text!,
        name: nameTextField.text!,
        password: passwordTextField.text!)
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
  
  func closeViewController() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  // MARK: - Private Methods
  
  private func errorMessage() -> String? {
    if emailTextField.text == nil || !emailTextField.text!.isValidEmail() {
      return NSLocalizedString("check email form", comment: "alert")
    } else if nameTextField.text == nil || nameTextField.text!.isEmpty {
      return NSLocalizedString("enter name", comment: "alert")
    } else if passwordTextField.text == nil || !passwordTextField.text!.isValidPassword() {
      return NSLocalizedString("password length is invalid", comment: "alert")
    } else if passwordTextField.text != passwordVerifyingTextField.text {
      return NSLocalizedString("check each password", comment: "alert")
    }
    for agreementButton in agreementButtons {
      if !agreementButton.selected {
        return NSLocalizedString("need agreement all rule", comment: "alert")
      }
    }
    return nil
  }
  
  // TODO: - webview 연결
}

// MARK: - UITextFieldDelegate

extension SignUpViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      nameTextField.becomeFirstResponder()
    } else if textField == nameTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      passwordVerifyingTextField.becomeFirstResponder()
    } else if textField == passwordVerifyingTextField {
      view.endEditing(true)
    }
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    textField.text = textField.text?.emailCharacterString()
  }
}