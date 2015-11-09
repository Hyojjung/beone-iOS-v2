
import UIKit

class SignInViewController: BaseViewController {
  
  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordTextField: UIFloatLabelTextField!
  
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
    ViewControllerHelper.setUpFloatingLabel(passwordTextField,
      placeholder: NSLocalizedString("password form", comment: "placeholder"))
    
    emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    passwordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  // MARK: - Actions
  
  @IBAction func backButtonTapped() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func signInButtonTapped() {
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage, hasCancel: false, confirmAction: nil, cancelAction: nil)
    } else {
      SigningHelper.signIn(emailTextField.text!,
        password: passwordTextField.text!)
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
    } else if passwordTextField.text == nil || !passwordTextField.text!.isValidPassword() {
      return NSLocalizedString("password length is invalid", comment: "alert")
    }
    return nil
  }
}

// MARK: - UITextFieldDelegate

extension SignInViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      signInButtonTapped()
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
