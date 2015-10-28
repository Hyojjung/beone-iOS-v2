//
//  TemplateInterface.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kTemplatePropertyKeyType = "type"
let kTemplatePropertyKeyStyle = "style"
let kTemplatePropertyKeyHasSpace = "hasSpace"
let kTemplatePropertyKeyRow = "row"
let kTemplatePropertyKeyColomn = "colomn"
let kTemplatePropertyKeyCount = "count"
let kTemplatePropertyKeyContents = "contents"
let kTemplatePropertyKeyItems = "items"

enum TemplateType: Int {
  case Text = 1
  case Image
  case Button
  case Gap
  case Shop
  case Product
  case Review
  case Banner
  case Table
  case Group = 101
}

class BaseTemplate: BaseModel {
  let type: TemplateType
  let style: TemplateStyle
  
  // MARK: - Init & Dealloc Methods

  init(type: TemplateType, style: [String: AnyObject]) {
    self.type = type
    self.style = TemplateStyle()
    self.style.assignObject(style)
  }
  
  // MARK: - Public Methods
  
  func layout() {
    preconditionFailure("This method must be overridden")
  }
}