//
//  ShopList.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 17..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ShopList: BaseListModel {
  override func fetchUrl() -> String {
    return "shops"
  }
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let shopList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for shopObject in shopList {
        let shop = Shop()
        shop.assignObject(shopObject)
        list.append(shop)
      }
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchShopListSuccess, object: nil)
    }
  }
}
