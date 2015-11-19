
import UIKit

class Product: BaseModel {
  private let kProductPropertyKeyMainImageUrl = "mainImageUrl"
  private let kProductPropertyKeyTitle = "title"
  private let kProductPropertyKeyActualPrice = "actualPrice"
  private let kProductPropertyKeyPrice = "price"
  private let kProductPropertyKeySubtitle = "subtitle"
  private let kProductPropertyKeyOnSale = "onSale"
  private let kProductPropertyKeyProductOrderableInfos = "productOrderableInfos"
  
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
  
  var productDetails: AnyObject?
  var productOrderableInfos = [ProductOrderableInfo]()
  var shop: AnyObject?
  
  func originalPriceAttributedString() -> NSAttributedString? {
    let productPrice = self.price?.priceNotation(.None)
    if self.onSale != nil && self.onSale! && productPrice != nil {
      let originalPrice = NSMutableAttributedString(string: productPrice!)
      originalPrice.addAttribute(NSStrikethroughStyleAttributeName,
        value: NSUnderlineStyle.StyleSingle.rawValue,
        range: NSMakeRange(0, productPrice!.characters.count))
      return originalPrice
    }
    return nil
  }
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      let productObejct = data[kNetworkResponseKeyData] != nil ? data[kNetworkResponseKeyData] : data
      if let product = productObejct as? [String: AnyObject] {
        id = product[kObjectPropertyKeyId] as? Int
        mainImageUrl = product[kProductPropertyKeyMainImageUrl] as? String
        title = product[kProductPropertyKeyTitle] as? String
        actualPrice = product[kProductPropertyKeyActualPrice] as? Int
        price = product[kProductPropertyKeyPrice] as? Int
        subtitle = product[kProductPropertyKeySubtitle] as? String
        onSale = product[kProductPropertyKeyOnSale] as? Bool
        if let productOrderableInfosObject = product[kProductPropertyKeyProductOrderableInfos] as? [[String: AnyObject]] {
          productOrderableInfos.removeAll()
          for productOrderableInfoObject in productOrderableInfosObject {
            let productOrderableInfo = ProductOrderableInfo()
            productOrderableInfo.assignObject(productOrderableInfoObject)
            productOrderableInfos.append(productOrderableInfo)
          }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchProductSuccess, object: nil)
      }
    }
  }
  
  override func fetchUrl() -> String {
    if let id = id {
      return "products/\(id)"
    }
    return "products"
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
