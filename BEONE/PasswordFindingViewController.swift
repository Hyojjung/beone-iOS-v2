
import UIKit

class PasswordFindingViewController: BaseViewController {
  
  // MARK: - Property

  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!

  // MARK: - BaseViewController Methods

  override func setUpView() {
    super.setUpView()
    emailTextField.setUpFloatingLabel(NSLocalizedString("email form", comment: "email form"))
    emailTextField.addTarget(self, action: #selector(PasswordFindingViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PasswordFindingViewController.handleSuccess), name: kNotificationRequestFindingPasswordSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PasswordFindingViewController.handleFailure(_:)), name: kNotificationRequestFindingPasswordFailure, object: nil)
  }
}

// MARK: - Actions

extension PasswordFindingViewController {
  @IBAction func passwordFindButtonTapped() {
    endEditing()
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage)
    } else if let email = emailTextField.text {
      SigningHelper.requestFindingPassword(email)
    }
  }
  
  @IBAction func backButtonTapped() {
    popView()
  }
}

// MARK: - Observer Actions

extension PasswordFindingViewController {
  func handleSuccess() {
    let popAction = Action()
    popAction.type = .Method
    popAction.content = "popView"
    showAlertView(NSLocalizedString("email sended", comment: "email sended"), hasCancel: false, confirmAction: popAction, cancelAction: nil, delegate: self)
  }
  
  func handleFailure(notification: NSNotification) {
    if let userInfo = notification.userInfo, statusCode = userInfo[kNotificationKeyErrorStatusCode] as? Int {
      switch statusCode {
      case NetworkResponseCode.NotFound.rawValue:
        showAlertView(NSLocalizedString("email not found", comment: "alert"))
      default:
        break
      }
    }
  }
}

// MARK: - Private Methods

extension PasswordFindingViewController {
  private func errorMessage() -> String? {
    if emailTextField.text == nil || !emailTextField.text!.isValidEmail() {
      return NSLocalizedString("check email form", comment: "alert")
    }
    return nil
  }
}

// MARK: - UITextFieldDelegate

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