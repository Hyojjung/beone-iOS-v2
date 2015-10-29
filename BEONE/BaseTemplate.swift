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

class Template: BaseModel {
  let type: TemplateType
  let style: TemplateStyle
  var contents = [Contents]()
  
  var hasSpace: Bool?
  var row: Int?
  var colomn: Int?
  var count: Int?
  
  var items = [Template]()
  
  // MARK: - Init & Dealloc Methods
  
  init(type: TemplateType, style: [String: AnyObject]) {
    self.type = type
    self.style = TemplateStyle()
    self.style.assignObject(style)
  }
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      hasSpace = template[kTemplatePropertyKeyHasSpace] as? Bool
      row = template[kTemplatePropertyKeyRow] as? Int
      colomn = template[kTemplatePropertyKeyColomn] as? Int
      count = template[kTemplatePropertyKeyCount] as? Int
      if let contents = template[kTemplatePropertyKeyContents] as? [[String: AnyObject]] {
        for contentObject in contents {
          let content = Contents()
          content.assignObject(contentObject)
          self.contents.append(content)
        }
      }
      if let itemObjects = template[kTemplatePropertyKeyItems] as? [[String: AnyObject]] {
        for itemObject in itemObjects {
          if let typeRawValue = itemObject[kTemplatePropertyKeyType] as? Int,
            styleObject = itemObject[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
              if let type = TemplateType(rawValue: typeRawValue) {
                let item = Template(type: type, style: styleObject)
                item.assignObject(itemObject)
                items.append(item)
              }
          }
        }
      }
    }
  }
  
  // MARK: - Public Methods
  
  func layout() {
    preconditionFailure("This method must be overridden")
  }
}