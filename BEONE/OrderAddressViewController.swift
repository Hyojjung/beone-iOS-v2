//
//  OrderAddressViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 20..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class OrderAddressViewController: BaseViewController {

  // MARK: - Init & Deinit

  deinit {
    if BEONEManager.ordering {
      // TODO: clearOrderingCartItems
    }
  }
  
  override func setUpView() {
    super.setUpView()
  }
  
  override func addObservers() {
    super.addObservers()
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView("postcodes", title: NSLocalizedString("order view title", comment: "view title"))
  }
}
