
import UIKit

class Product: BaseModel {
  private let kProductPropertyKeyMainImageUrl = "mainImageUrl"
  private let kProductPropertyKeyTitle = "title"
  private let kProductPropertyKeyActualPrice = "actualPrice"
  private let kProductPropertyKeyPrice = "price"
  private let kProductPropertyKeySubtitle = "subtitle"
  private let kProductPropertyKeySummary = "summary"
  private let kProductPropertyKeyOnSale = "isOnSale"
  private let kProductPropertyKeyQuantity = "quantity"
  private let kProductPropertyKeyProductCode = "productCode"
  private let kProductPropertyKeyCountryInfo = "countryInfo"
  private let kProductPropertyKeySize = "size"
  private let kProductPropertyKeyShelfLife = "shelfLife"
  private let kProductPropertyKeyComposition = "composition"
  private let kProductPropertyKeyRelatedLayInfo = "relatedLawInfo"
  private let kProductPropertyKeyKeepingMethod = "keepingMethod"
  private let kProductPropertyKeyPrecaution = "precaution"
  private let kProductPropertyKeyContact = "contact"
  private let kProductPropertyKeyShop = "shop"
  private let kProductPropertyKeyProductOrderableInfos = "productOrderableInfos"
  private let kProductPropertyKeyProductDetails = "productDetails"
  private let kProductPropertyKeyIsSoldOut = "isSoldOut"
  
  var mainImageUrl: String?
  var title: String?
  var actualPrice = 0
  var price = 0
  var subtitle: String?
  var composition: String?
  var contact: String?
  var countryInfo: String?
  var keepingMethod: String?
  var onSale = false
  var precaution: String?
  var quantity = 1
  var discountPercent: Int?
  var productCode: String?
  var rate = 0.0
  var relatedLawInfo: String?
  var shelfLife: String?
  var shopId: Int?
  var significantlyUpdatedAt: NSDate?
  var size: String?
  var soldOut = false
  var summary: String?
  
  var productDetails = [ProductDetail]()
  var productOptionSets = ProductOptionSetList()
  var productOrderableInfos = [ProductOrderableInfo]()
  var shop = Shop()
  
  // MARK: - BaseModel Methods
  
  override func fetchUrl() -> String {
    if let id = id {
      return "products/\(id)"
    }
    return "products"
  }
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      let isInList = data[kNetworkResponseKeyData] != nil
      let productObejct = isInList ? data[kNetworkResponseKeyData] : data
      if let product = productObejct as? [String: AnyObject] {
        id = product[kObjectPropertyKeyId] as? Int
        mainImageUrl = product[kProductPropertyKeyMainImageUrl] as? String
        title = product[kProductPropertyKeyTitle] as? String
        if let actualPrice = product[kProductPropertyKeyActualPrice] as? Int {
          self.actualPrice = actualPrice
        }
        if let price = product[kProductPropertyKeyPrice] as? Int {
          self.price = price
        }
        if let onSale = product[kProductPropertyKeyOnSale] as? Bool {
          self.onSale = onSale
        }
        if price != 0 && onSale {
          let price = CGFloat(self.price)
          let actualPrice = CGFloat(self.actualPrice)
          discountPercent = Int((price - actualPrice) / price * 100)
        }
        if let quantity = product[kProductPropertyKeyQuantity] as? Int {
          self.quantity = quantity
        }
        subtitle = product[kProductPropertyKeySubtitle] as? String
        summary = product[kProductPropertyKeySummary] as? String
        productCode = product[kProductPropertyKeyProductCode] as? String
        countryInfo = product[kProductPropertyKeyCountryInfo] as? String
        size = product[kProductPropertyKeySize] as? String
        shelfLife = product[kProductPropertyKeyShelfLife] as? String
        composition = product[kProductPropertyKeyComposition] as? String
        relatedLawInfo = product[kProductPropertyKeyRelatedLayInfo] as? String
        keepingMethod = product[kProductPropertyKeyKeepingMethod] as? String
        precaution = product[kProductPropertyKeyPrecaution] as? String
        contact = product[kProductPropertyKeyContact] as? String
        if let soldOut = product[kProductPropertyKeyIsSoldOut] as? Bool {
          self.soldOut = soldOut
        }
        assignProductOrderableInfos(product[kProductPropertyKeyProductOrderableInfos])
        assignProductDetails(product[kProductPropertyKeyProductDetails])
        if let shopObject = product[kProductPropertyKeyShop]{
          shop.assignObject(shopObject)
        }
        if let productOptionSetObjects = product["productOptionSets"] as? [[String: AnyObject]] {
          productOptionSets.assignObject(productOptionSetObjects)
        }
        if isInList {
          postNotification(kNotificationFetchProductSuccess)
        }
      }
    }
  }
  
  private func assignProductOrderableInfos(productOrderableInfosObject: AnyObject?) {
    if let productOrderableInfosObject = productOrderableInfosObject as? [[String: AnyObject]] {
      productOrderableInfos.removeAll()
      for productOrderableInfoObject in productOrderableInfosObject {
        let productOrderableInfo = ProductOrderableInfo()
        productOrderableInfo.assignObject(productOrderableInfoObject)
        productOrderableInfos.append(productOrderableInfo)
      }
    }
  }
  
  private func assignProductDetails(productDetailsObject: AnyObject?) {
    if let productDetailsObject = productDetailsObject as? [[String: AnyObject]] {
      productDetails.removeAll()
      for productDetailObject in productDetailsObject {
        let productDetail = ProductDetail()
        productDetail.assignObject(productDetailObject)
        productDetails.append(productDetail)
      }
    }
  }
}

// MARK: - Publice Methods

extension Product {
  func priceAttributedString() -> NSAttributedString? {
    let priceString = price.priceNotation(.None)
    if onSale {
      let originalPrice = NSMutableAttributedString(string: priceString)
      originalPrice.addAttribute(NSStrikethroughStyleAttributeName,
        value: NSUnderlineStyle.StyleSingle.rawValue,
        range: NSMakeRange(0, priceString.characters.count))
      return originalPrice
    }
    return nil
  }
  
  func productDetailImageUrls() -> [String] {
    var imageUrls = [String]()
    for productDetail in productDetails {
      if productDetail.detailType == .Image && productDetail.content != nil {
        imageUrls.append(productDetail.content!)
      }
    }
    if imageUrls.isEmpty && mainImageUrl != nil {
      imageUrls.append(mainImageUrl!)
    }
    return imageUrls
  }
}

extension Int {
  enum NotationType: String {
    case None = ""
    case English = " won"
    case Korean = " 원"
    case KoreanFreeNotation = "무료"
  }
  
  func priceNotation(notationType: NotationType) -> String {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    if notationType == .KoreanFreeNotation && self == 0 {
      return notationType.rawValue
    } else if let priceNotation = formatter.stringFromNumber(NSNumber(integer: self)) {
      if notationType == .KoreanFreeNotation {
        return "\(priceNotation)\(NotationType.Korean.rawValue)"
      }
      return "\(priceNotation)\(notationType.rawValue)"
    }
    return "0\(notationType.rawValue)"
  }
}
