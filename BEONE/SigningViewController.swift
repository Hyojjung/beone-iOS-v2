
import UIKit
import FBSDKLoginKit

class SigningViewController: BaseViewController {
  
  // MARK: - Constant

  private let kSegueIdentifierFromSigningToSnsSignUp = "From Signing To Sns Sign Up"
  private let kSegueIdentifierFromSigningToEmailSignUp = "From Signing To Email Sign Up"
  private let kSegueIdentifierFromSigningToEmailSignIn = "From Signing To Email Sign In"
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    navigationController?.navigationBar.hidden = true
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(SigningViewController.closeButtonTapped),
      name: kNotificationSigningSuccess,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(SigningViewController.handleSnsSignInFailure),
      name: kNotificationNeedSignUp,
      object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationSigningSuccess, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationNeedSignUp, object: nil)
  }
}

// MARK: - View Cycles

extension SigningViewController {
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    loadingView.hide()
  }
}

// MARK: - Actions

extension SigningViewController {
  @IBAction func closeButtonTapped() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func facebookSignInButtonTapped() {
    let logInManager = FBSDKLoginManager()
    logInManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self)
      { (result, error) -> Void in
        if !result.isCancelled {
          self.loadingView.show()
          KOSession.sharedSession().close()
          FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
          SigningHelper.requestFacebookSignIn()
        }
    }
  }
  
  @IBAction func kakaotalkSignInButtonTapped() {
    KOSession.sharedSession().openWithCompletionHandler() { (error) -> Void in
      if KOSession.sharedSession().isOpen() {
        self.loadingView.show()
        FBSDKLoginManager().logOut()
        SigningHelper.requestKakaoSignIn() {(uid, snsToken) in
          SigningHelper.signIn(.Kakao, userId: uid, token: snsToken)
        }
      }
    }
  }
  
  @IBAction func signingWithEmailButtonTapped() {
    let signInButton = ActionSheetButton(title: NSLocalizedString("sign in", comment: "button title"))
      {(_) -> Void in
        self.performSegueWithIdentifier(self.kSegueIdentifierFromSigningToEmailSignIn, sender: nil)
    }
    let signUpButton = ActionSheetButton(title: NSLocalizedString("sign up", comment: "button title"))
      {(_) -> Void in
        self.performSegueWithIdentifier(self.kSegueIdentifierFromSigningToEmailSignUp, sender: nil)
    }
    
    showActionSheet([signInButton, signUpButton])
  }
}

// MARK: - Observer Actions

extension SigningViewController {
  
  func handleSnsSignInFailure() {
    performSegueWithIdentifier(kSegueIdentifierFromSigningToSnsSignUp, sender: nil)
  }
}
