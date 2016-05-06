
import UIKit

class SignInViewController: BaseViewController {
  
  // MARK: - Property
  
  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordTextField: UIFloatLabelTextField!
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    emailTextField.setUpFloatingLabel(NSLocalizedString("email form", comment: "placeholder"))
    passwordTextField.setUpFloatingLabel(NSLocalizedString("password form", comment: "placeholder"))
    
    emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
}

// MARK: - View Cycles

extension SignInViewController {
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController!.navigationBar.hidden = true
  }
}

// MARK: - Actions

extension SignInViewController {
  @IBAction func backButtonTapped() {
    popView()
  }
  
  @IBAction func signInButtonTapped() {
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage)
    } else {
      SigningHelper.signIn(emailTextField.text!,
                           password: passwordTextField.text!,
                           success: {
                            if !SchemeHelper.schemeStrings.isEmpty {
                              SchemeHelper.schemeStrings.insert(kEmptyString, atIndex: 0)
                            }
                            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        },
                           failure: {
                            self.showAlertView(NSLocalizedString("not exist account", comment: "alert"))
      })
    }
  }
}

// MARK: - Private Methods

extension SignInViewController {
  private func errorMessage() -> String? {
    if emailTextField.text == nil || !emailTextField.text!.isValidEmail() {
      return NSLocalizedString("check email form", comment: "alert")
    } else if passwordTextField.text == nil || !passwordTextField.text!.isValidPassword() {
      return NSLocalizedString("check password form", comment: "alert")
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
