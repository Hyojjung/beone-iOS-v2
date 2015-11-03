//
//  TemplateContentsView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateContentsView: UIView {
  var action: Action?

  func layoutView(template: Template) {
      preconditionFailure("This method must be overriden")
  }
}
