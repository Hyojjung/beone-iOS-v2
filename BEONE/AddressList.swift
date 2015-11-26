//
//  AddressList.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 25..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class AddressList: BaseListModel {
  override func fetchUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-infos"
    }
    return "users/delivery-infos"
  }
  
  override func assignObject(data: AnyObject) {
    print(data)
  }
}
