
import UIKit
import FBSDKLoginKit

class SnsSignUpViewController: BaseViewController {
  
  // MARK: - Property
  
  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var emailTextField: UIFloatLabelTextField!
  @IBOutlet weak var nameTextField: UIFloatLabelTextField!
  @IBOutlet var agreementButtons: [UIButton]!
  @IBOutlet weak var allAgreementButton: UIButton!
  
  var snsType: SnsType?
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(SnsSignUpViewController.setUpTextField(_:)),
      name: kNotificationFetchFacebookInfoSuccess,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(SnsSignUpViewController.setUpTextField(_:)),
      name: kNotificationFetchKakaoInfoSuccess,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(SnsSignUpViewController.closeViewController),
      name: kNotificationSigningSuccess,
      object: nil)
  }
  
  override func setUpView() {
    super.setUpView()
    emailTextField.setUpFloatingLabel(NSLocalizedString("email form", comment: "placeholder"))
    nameTextField.setUpFloatingLabel(NSLocalizedString("name form", comment: "placeholder"))
    emailTextField.addTarget(self, action: #selector(SnsSignUpViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
  
  override func setUpData() {
    super.setUpData()
    SigningHelper.getFaceBookInfo()
    SigningHelper.getKakaoInfo()
  }
}

// MARK: - View Cycles

extension SnsSignUpViewController {
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController!.navigationBar.hidden = true
  }
}

// MARK: - Actions

extension SnsSignUpViewController {
  @IBAction func backButtonTapped() {
    popView()
  }
  
  @IBAction func snsSignUpButtonTapped() {
    if let errorMessage = errorMessage() {
      showAlertView(errorMessage)
    } else if let snsType = snsType {
      if snsType == .Facebook {
        SigningHelper.signUp(snsType,
                             userId: FBSDKAccessToken.currentAccessToken().userID,
                             token: FBSDKAccessToken.currentAccessToken().tokenString,
                             email: emailTextField.text!,
                             name: nameTextField.text!)
      } else {
        SigningHelper.kakaoSessionMeTask() { (user) -> Void in
          SigningHelper.signUp(snsType,
            userId: user.ID.description,
            token: KOSession.sharedSession().accessToken,
            email: self.emailTextField.text!,
            name: self.nameTextField.text!)
        }
      }
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

extension SnsSignUpViewController {
  func setUpTextField(notification: NSNotification) {
    if let userInfo = notification.userInfo as? [String: String] {
      snsType = notification.name == kNotificationFetchFacebookInfoSuccess ? SnsType.Facebook : SnsType.Kakao
      emailTextField.text = userInfo[kNotificationKeyFacebookEmail]
      nameTextField.text = userInfo[kNotificationKeyFacebookName]
    }
  }
  
  func closeViewController() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}


// MARK: - Private Methods

extension SnsSignUpViewController {
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
}

// MARK: - UITextFieldDelegate

extension SnsSignUpViewController {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailTextField {
      nameTextField.becomeFirstResponder()
    } else if textField == nameTextField {
      endEditing()
    }
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    textField.text = textField.text?.emailCharacterString()
  }
}