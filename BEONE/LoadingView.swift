//
//  LoadingView.swift
//  BOFlorist
//
//  Created by 효정 김 on 2015. 9. 7..
//  Copyright (c) 2015년 효정 김. All rights reserved.
//

import UIKit

class LoadingView: UIView {
  
  let indicator = UIActivityIndicatorView()
  
  func layout() {
    translatesAutoresizingMaskIntoConstraints = false
    hide()
    
    backgroundColor = UIColor.clearColor()
    let blurEffect = UIBlurEffect(style: .Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(blurEffectView)
    addConstraint(NSLayoutConstraint(item: blurEffectView,
      attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.Leading,
      multiplier: 1.0,
      constant: 0.0))
    addConstraint(NSLayoutConstraint(item: blurEffectView,
      attribute: NSLayoutAttribute.Trailing,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.Trailing,
      multiplier: 1.0,
      constant: 0.0))
    addConstraint(NSLayoutConstraint(item: blurEffectView,
      attribute: NSLayoutAttribute.Bottom,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.Bottom,
      multiplier: 1.0,
      constant: 0.0))
    addConstraint(NSLayoutConstraint(item: blurEffectView,
      attribute: NSLayoutAttribute.Top,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.Top,
      multiplier: 1.0,
      constant: 0.0))
    // background view
    
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.color = darkGold
    addSubview(indicator)
    addConstraint(NSLayoutConstraint(item: indicator,
      attribute: NSLayoutAttribute.CenterX,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.CenterX,
      multiplier: 1.0,
      constant: 0.0))
    addConstraint(NSLayoutConstraint(item: indicator,
      attribute: NSLayoutAttribute.CenterY,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.CenterY,
      multiplier: 1.0,
      constant: 0.0))
    indicator.startAnimating()
    // indicator
  }
  
  func show() {
    hidden = false
  }
  
  func hide() {
    hidden = true
  }
}
