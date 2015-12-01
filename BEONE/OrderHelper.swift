//
//  OrderHelper.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class OrderHelper: NSObject {
  static func fetchOrderableInfo(cartItemIds: [Int]) {
    if MyInfo.sharedMyInfo().isUser() {
      NetworkHelper.requestGet("users/\(MyInfo.sharedMyInfo().userId!)/helpers/order/orderable",
        parameter: ["cartItemIds": cartItemIds], success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
            BEONEManager.selectedOrder.assignObject(data)
          }
        }, failure: { (error) -> Void in
          print(error)
      })
    }
  }
}
