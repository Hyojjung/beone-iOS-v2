//
//  Shop.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 17..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class Shop: BaseModel {
  private let kShopPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
  private let kShopPropertyKeyName = "name"
  private let kShopPropertyKeyProfileImageUrl = "profileImageUrl"
  private let kShopPropertyKeyDescription = "description"
  
  var backgroundImageUrl: String?
  var name: String?
  var profileImageUrl: String?
  var summary: String?
  
  override func assignObject(data: AnyObject) {
    if let shop = data as? [String: AnyObject] {
      backgroundImageUrl = shop[kShopPropertyKeyBackgroundImageUrl] as? String
      name = shop[kShopPropertyKeyName] as? String
      profileImageUrl = shop[kShopPropertyKeyProfileImageUrl] as? String
      summary = shop[kShopPropertyKeyDescription] as? String
    }
  }
}
