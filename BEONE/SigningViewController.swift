//
//  SigningViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit
import FBSDKLoginKit

let kSegueIdentifierFromSigningToSnsSignUp = "From Signing To Sns Sign Up"
let kSegueIdentifierFromSigningToEmailSignUp = "From Signing To Email Sign Up"
let kSegueIdentifierFromSigningToEmailSignIn = "From Signing To Email Sign In"

class SigningViewController: BaseViewController {
  
  // MARK: - View Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.hidden = true
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    loadingView.hide()
  }
  
  // MARK: - Override Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "closeButtonTapped",
      name: kNotificationSigningSuccess,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleSnsSignInFailure",
      name: kNotificationNeedSignUp,
      object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - Actions
  
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
          AuthenticationHelper.requestFacebookSignIn()
        }
    }
  }
  
  @IBAction func kakaotalkSignInButtonTapped() {
    KOSession.sharedSession().openWithCompletionHandler() { (error) -> Void in
      if KOSession.sharedSession().isOpen() {
        self.loadingView.show()

        FBSDKLoginManager().logOut()
        AuthenticationHelper.requestKakaoSignIn()
      }
    }
  }
  
  @IBAction func signingWithEmailButtonTapped() {
    let signInButton = ActionSheetButton(title: NSLocalizedString("sign in", comment: "button title"))
      {(_) -> Void in
        self.performSegueWithIdentifier(kSegueIdentifierFromSigningToEmailSignIn, sender: nil)
    }
    let signUpButton = ActionSheetButton(title: NSLocalizedString("sign up", comment: "button title"))
      {(_) -> Void in
        self.performSegueWithIdentifier(kSegueIdentifierFromSigningToEmailSignUp, sender: nil)
    }
    
    ViewControllerHelper.showActionSheet(self, title: nil, actionSheetButtons: [signInButton, signUpButton])
  }
  
  // MARK: - Observer Action
  
  func handleSnsSignInFailure() {
    performSegueWithIdentifier(kSegueIdentifierFromSigningToSnsSignUp, sender: nil)
  }
}
