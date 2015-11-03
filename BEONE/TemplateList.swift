//
//  TemplateList.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 1..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateList: BaseListModel {
  override func assignObject(data: AnyObject) {
    if let templateList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for templateObject in templateList {
        let template = Template()
        template.assignObject(templateObject)
        list.append(template)
      }
    }
  }
}
