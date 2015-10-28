//
//  TableTemplate.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TableTemplate: BaseTemplate {
  var hasSpace: Bool?
  var row: Int?
  var colomn: Int?
  var count: Int?
  var contents = [Contents]()
  
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
    }
  }
}
