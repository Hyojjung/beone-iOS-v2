
import UIKit

class PasswordChangingViewController: BaseViewController {
  
  @IBOutlet weak var passwordTextField: UIFloatLabelTextField!
  @IBOutlet weak var newPasswordTextField: UIFloatLabelTextField!
  @IBOutlet weak var newPasswordVerificationTextField: UIFloatLabelTextField!
  
  override func setUpView() {
    super.setUpView()
    passwordTextField.setUpFloatingLabel(NSLocalizedString("established password form", comment: "floating label"))
    newPasswordTextField.setUpFloatingLabel(NSLocalizedString("new password form", comment: "floating label"))
    newPasswordVerificationTextField.setUpFloatingLabel(NSLocalizedString("verify password form", comment: "floating label"))
  }
  
  @IBAction func changePasswordButtonTapped() {
    if passwordTextField.text?.isValidPassword() == true
      && newPasswordTextField.text?.isValidPassword() == true
      && newPasswordVerificationTextField.text?.isValidPassword() == true {
      if newPasswordTextField.text == newPasswordVerificationTextField.text {
        changePassword()
      } else {
        showAlertView(NSLocalizedString("check each password", comment: "alert title"))
      }
    } else {
      showAlertView(NSLocalizedString("check password form", comment: "alert title"))
    }
  }
  
  func changePassword() {
    endEditing()
    MyInfo.sharedMyInfo().changePassword(passwordTextField.text!,
                                         newPassword: newPasswordTextField.text!,
                                         success: {
                                          self.popView()
      }, failure: {(networkError) in
        if let statusCode = networkError.statusCode {
          if statusCode == NetworkResponseCode.Invalid {
            self.showAlertView(NSLocalizedString("check established password", comment: "alert title"))
          }
        }
    })
  }
}

extension PasswordChangingViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == passwordTextField {
      newPasswordTextField.becomeFirstResponder()
    } else if textField == newPasswordTextField {
      newPasswordVerificationTextField.becomeFirstResponder()
    } else {
      endEditing()
    }
    return true
  }
}
