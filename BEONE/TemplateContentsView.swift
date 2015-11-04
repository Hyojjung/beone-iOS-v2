//
//  TemplateContentsView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateContentsView: UIView, TemplateContentsViewProtocol {
  var templateId: NSNumber?
  var isLayouted = false
  
  func layoutView(template: Template) {
    preconditionFailure("This method must be overriden")
  }
}

protocol TemplateContentsViewProtocol {
  var templateId: NSNumber? { get set }
  var isLayouted: Bool { get set }
}

extension UIView {
  func layoutContentsView(isLayouted: Bool, templateId: NSNumber?, height: CGFloat, contentsView: UIView) {
    if isLayouted && templateId != nil {
      for constraint in contentsView.constraints {
        if constraint.firstAttribute == .Height &&
          Int(constraint.constant) != Int(height) &&
          constraint.isMemberOfClass(NSLayoutConstraint) {
            constraint.constant = height
            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationContentsViewLayouted,
              object: nil,
              userInfo: [kNotificationKeyTemplateId: templateId!, kNotificationKeyHeight: height])
            break;
        }
      }
    }
  }
}
