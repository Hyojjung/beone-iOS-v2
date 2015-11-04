//
//  LayoutHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 30..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

extension UIView {
  func addSubViewAndEnableAutoLayout(subView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subView)
  }
  
  func addSubViewAndLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Top,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Bottom,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Left,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Right,
      multiplier: 1,
      constant: 0))
  }
  
  func addSubViewAndMarginLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopMarginLayout(subView)
    addBottomMarginLayout(subView)
    addHorizontalMarginLayout(subView)
  }
  
  func addHorizontalMarginLayout(subView: UIView) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: self,
      attribute: .LeftMargin,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: self,
      attribute: .RightMargin,
      multiplier: 1,
      constant: 0))
  }
  
  func addTopMarginLayout(subView: UIView) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: .TopMargin,
      multiplier: 1,
      constant: 0))
  }
  
  func addBottomMarginLayout(subView: UIView) {
    let bottomMarginConstraint = NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: self,
      attribute: .BottomMargin,
      multiplier: 1,
      constant: 0)
    bottomMarginConstraint.priority = UILayoutPriorityDefaultHigh
    addConstraint(bottomMarginConstraint)
  }
  
  func changeHeightLayoutConstant(height: CGFloat?) {
    if let height = height {
      for constraint in constraints {
        if constraint.firstAttribute == .Height {
          constraint.constant = height
        }
      }
    }
  }
}
