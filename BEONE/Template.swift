//
//  Template.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class Template: BaseTemplate {
  var contents = Contents()
  
  // MARK: - Override Methods

  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      if let contentsObject = template[kTemplatePropertyKeyContents] as? [String: AnyObject] {
        contents.assignObject(contentsObject)
      }
    }
  }
}
