//
//  ProductList.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 18..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ProductList: BaseListModel {
  enum Type {
    case None
    case Shop
  }
  
  var type = Type.None
  
  override func fetchUrl() -> String {
    switch type {
    case .Shop:
      if let shopId = BEONEManager.selectedShop?.id {
        return "shops/\(shopId)/products"
      } else {
        return "products"
      }
    case .None:
      return "products"
    }
  }
  
  override func assignObject(data: AnyObject) {
    list.removeAll()
    if let productList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      for productObject in productList {
        let product = Product()
        product.assignObject(productObject)
        list.append(product)
      }
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchProductListSuccess, object: nil)
    }
  }
}
