//
//  SigningViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kSegueIdentifierFromSigningToSnsSignUp = "From Signing To Sns Sign Up"
let kSegueIdentifierFromSigningToEmailSignUp = "From Signing To Email Sign Up"
let kSegueIdentifierFromSigningToEmailSignIn = "From Signing To Email Sign In"


class SigningViewController: BaseViewController {
  
  // MARK: - View Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.hidden = true
  }
  
  // MARK: - Override Methods
  
  
  
  // MARK: - Actions

  @IBAction func closeButtonTapped() {
    parentViewController?.dismissViewControllerAnimated(true, completion: nil)
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
  
  
}
