//
//  Product.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 18..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class Product: BaseModel {
  var mainImageUrl: String?
  var title: String?
  var actualPrice: Int?
  var price: Int?
  var subtitle: String?
  var composition: String?
  var contact: String?
  var countryInfo: String?
  var keepingMethod: String?
  var onSale: Bool?
  var precaution: String?
  var quantity: Int?
  var productCode: String?
  var rate: Double?
  var relatedLawInfo: String?
  var shelfLife: String?
  var shopId: Int?
  var significantlyUpdatedAt: NSDate?
  var size: String?
  var soldOut: Bool?
  var summary: String?
  
  lazy var isOnSale: Bool = {
    return self.onSale != nil && self.onSale!
  }()
  
  override func assignObject(data: AnyObject) {
    print(data)
    if let product = data as? [String: AnyObject] {
      id = product[kObjectPropertyKeyId] as? Int
      mainImageUrl = product["mainImageUrl"] as? String
      title = product["title"] as? String
      actualPrice = product["actualPrice"] as? Int
      price = product["price"] as? Int
      subtitle = product["subtitle"] as? String
      onSale = product["onSale"] as? Bool
    }
  }
}

extension Int {
  enum NotationType: String {
    case None = ""
    case English = " won"
  }
  
  func priceNotation(notationType: NotationType) -> String {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    if let priceNotation = formatter.stringFromNumber(NSNumber(integer: self)) {
      return "\(priceNotation)\(notationType.rawValue)"
    }
    return "0\(notationType.rawValue)"
  }
}
