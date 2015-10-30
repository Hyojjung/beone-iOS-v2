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
let kTemplatePropertyKeyColumn = "col"
let kTemplatePropertyKeyCount = "count"
let kTemplatePropertyKeyContents = "contents"
let kTemplatePropertyKeyTemplateItems = "templateItems"
let kTemplatePropertyKeyIsGroup = "isGroup"

enum TemplateType: String {
  case Text = "text"
  case Image = "image"
  case Button
  case Gap
  case Shop
  case Product
  case Review
  case Banner
  case Table = "table"
}

class Template: BaseModel {
  var type: TemplateType?
  
  var style: TemplateStyle?
  var contents = [Contents]()
  var isGroup: Bool?
  
  var hasSpace: Bool?
  var row: Int?
  var column: Int?
  var count: Int?
  
  var templateItems = [Template]()
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject] {
      if let type = template[kTemplatePropertyKeyType] as? String {
        self.type = TemplateType(rawValue: type)
      }
      hasSpace = template[kTemplatePropertyKeyHasSpace] as? Bool
      row = template[kTemplatePropertyKeyRow] as? Int
      column = template[kTemplatePropertyKeyColumn] as? Int
      count = template[kTemplatePropertyKeyCount] as? Int
      isGroup = template[kTemplatePropertyKeyIsGroup] as? Bool
      if let style = template[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
        self.style = TemplateStyle()
        self.style!.assignObject(style)
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
}