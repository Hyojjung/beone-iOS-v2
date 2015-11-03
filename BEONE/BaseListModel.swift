//
//  BaseListModelProtocol.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 1..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kDefaultCountPerPage = 20

class BaseListModel: BaseModel {
  var count: Int?
  var total: Int?
  var page: Int?
  var list = [BaseModel]()
  
  func needFetch(index: Int) -> Bool {
    if let count = count, total = total {
      if count < total && index / kDefaultCountPerPage == 0 && count == index {
        return true
      }
    }
    return false
  }
}

