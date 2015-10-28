//
//  TemplateGroup.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateGroup: BaseTemplate {
  var items = [BaseTemplate]()
  
  // MARK: - Override Methods

  override func assignObject(data: AnyObject) {
    if let template = data as? [String: AnyObject],
      itemObjects = template[kTemplatePropertyKeyItems] as? [[String: AnyObject]] {
        for itemObject in itemObjects {
          if let typeRawValue = itemObject[kTemplatePropertyKeyType] as? Int,
            styleObject = itemObject[kTemplatePropertyKeyStyle] as? [String: AnyObject] {
              if let type = TemplateType(rawValue: typeRawValue) {
                let item = BaseTemplate(type: type, style: styleObject)
                item.assignObject(itemObject)
                items.append(item)
              }
          }
        }
    }
  }
}
