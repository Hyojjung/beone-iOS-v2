//
//  BaseViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  private let backButtonOffset = UIOffsetMake(0, -60)
  
//  lazy var loadingView: LoadingView = {
//    let loadingView = LoadingView()
//    loadingView.layout()
//    self.view.addSubview(loadingView)
//    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
//      attribute: NSLayoutAttribute.Leading,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: self.view,
//      attribute: NSLayoutAttribute.Leading,
//      multiplier: 1.0,
//      constant: 0.0))
//    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
//      attribute: NSLayoutAttribute.Trailing,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: self.view,
//      attribute: NSLayoutAttribute.Trailing,
//      multiplier: 1.0,
//      constant: 0.0))
//    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
//      attribute: NSLayoutAttribute.Bottom,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: self.view,
//      attribute: NSLayoutAttribute.Bottom,
//      multiplier: 1.0,
//      constant: 0.0))
//    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
//      attribute: NSLayoutAttribute.Top,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: self.view,
//      attribute: NSLayoutAttribute.Top,
//      multiplier: 1.0,
//      constant: 0.0))
//    return loadingView
//    }()
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
    return tapRecognizer
    }()
  
  func endEditing() {
    view.endEditing(true)
  }
  
  // MARK: - View Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    ViewControllerHelper.frontViewController = self
    setUpView()
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
//    ViewControllerHelper.frontViewController = self
    addObservers()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
  }
  
  // MARK: - DynamicHeightTableViewProtocol
  
  func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    cell.selectionStyle = .None
  }
  
  // MARK: - Private Methods
  
  func setUpView() {
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(backButtonOffset,
      forBarMetrics: .Default)
  }
  
  func addObservers() {
//    NSNotificationCenter.defaultCenter().addObserver(self,
//      selector: "startIndicator",
//      name: kNotificationNetworkStart,
//      object: nil)
//    NSNotificationCenter.defaultCenter().addObserver(self,
//      selector: "stopIndicator",
//      name: kNotificationNetworkEnd,
//      object: nil)
  }
  
  func removeObservers() {
//    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationNetworkStart, object: nil)
//    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationNetworkEnd, object: nil)
  }
  
  func popView() {
    navigationController?.popViewControllerAnimated(true)
  }
  
//  func startIndicator() {
//    loadingView.hidden = false
//  }
//  
//  func stopIndicator() {
//    loadingView.hidden = true
//  }
}