
import UIKit

class SignUpViewController: BaseViewController {
  
  // MARK: - Property

  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!
  @IBOutlet weak var nameTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordTextField: UIFloatLabelTextField!
  @IBOutlet weak var passwordVerifyingTextField: UIFloatLabelTextField!
  @IBOutlet var agreementButtons: [UIButton]!
  @IBOutlet weak var allAgreementButton: UIButton!
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "closeViewController",
      name: kNotificationSigningSuccess,
      object: nil)
  }
  
  override func setUpView() {
    super.setUpView()
    emailTextField.setUpFloatingLabel(NSLocalizedString("email form", comment: "placeholder"))
    nameTextField.setUpFloatingLabel(NSLocalizedString("name form", comment: "placeholder"))
    passwordTextField.setUpFloatingLabel(NSLocalizedString("password form", comment: "placeholder"))
    passwordVerifyingTextField.setUpFloatingLabel(NSLocalizedString("password form", comment: "placeholder"))
    
    emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    passwordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    passwordVerifyingTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
}

// MARK: - View Cycles

extension SignUpViewController {
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController!.navigationBar.hidden = true
  }
}

// MARK: - Actions

extension SignUpViewController {
  @IBAction func backButtonTapped() {
    popView()
  }
  
  @IBAction func signUpButtonTapped() {
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage)
    } else {
      SigningHelper.signUp(emailTextField.text!,
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
  
  @IBAction func servicePolicyButtonTapped() {
    showWebView("\(kBaseApiUrl)\(kServicePolicyUrlString)", title: NSLocalizedString("service policy", comment: "title"))
  }
  
  @IBAction func privacyPolicyButtonTapped() {
    showWebView("\(kBaseApiUrl)\(kPrivacyPolicyUrlString)", title: NSLocalizedString("privacy policy", comment: "title"))
  }
}

// MARK: - Observer Actions

extension SignUpViewController {
  func closeViewController() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}


// MARK: - Private Methods

extension SignUpViewController {
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
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    scrollView.focusOffset = textField.frame.origin.y - emailTextField.frame.origin.y
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    textField.text = textField.text?.emailCharacterString()
  }
}