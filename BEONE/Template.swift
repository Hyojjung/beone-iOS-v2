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
let kTemplatePropertyKeyTemplateItems = "templateItems"
let kTemplatePropertyKeyIsGroup = "isGroup"

enum TemplateType: String {
  case Text = "text"
  case Image
  case Button
  case Gap
  case Shop
  case Product
  case Review
  case Banner
  case Table
}

class Template: BaseModel {
  var type: TemplateType?
  
  var style: TemplateStyle?
  var contents = [Contents]()
  var isGroup: Bool?
  
  var hasSpace: Bool?
  var row: Int?
  var colomn: Int?
  var count: Int?
  
  var templateItems = [Template]()
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      if let typeString = template[kTemplatePropertyKeyType] as? String {
        type = TemplateType(rawValue: typeString)
      }
      hasSpace = template[kTemplatePropertyKeyHasSpace] as? Bool
      row = template[kTemplatePropertyKeyRow] as? Int
      colomn = template[kTemplatePropertyKeyColomn] as? Int
      count = template[kTemplatePropertyKeyCount] as? Int
      isGroup = template[kTemplatePropertyKeyIsGroup] as? Bool
      if let styleObject = template[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
        style = TemplateStyle()
        style!.assignObject(styleObject)
      }
      if let templateItemObjects = template[kTemplatePropertyKeyTemplateItems] as? [[String: AnyObject]] { // group
        for templateItemObject in templateItemObjects {
          let templateItem = Template()
          templateItem.assignObject(templateItemObject)
          templateItems.append(templateItem)
        }
      } else if let contents = template[kTemplatePropertyKeyContents] as? [[String: AnyObject]] { // something else
        for contentObject in contents {
          let content = Contents()
          content.assignObject(contentObject)
          self.contents.append(content)
        }
      }
    }
  }
  
  // MARK: - Public Methods
  
  func layout() {
    preconditionFailure("This method must be overridden")
  }
}