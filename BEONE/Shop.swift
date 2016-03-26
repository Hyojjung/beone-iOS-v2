
import UIKit

class Shop: BaseModel {
  private let kShopPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
  private let kShopPropertyKeyName = kObjectPropertyKeyName
  private let kShopPropertyKeyProfileImageUrl = "profileImageUrl"
  
  var backgroundImageUrl: String?
  var name: String?
  var profileImageUrl: String?
  var desc: String?
  var productsCount = 0
  var tags: [String]?
  
  override func assignObject(data: AnyObject?) {
    if let shop = data as? [String: AnyObject] {
      id = shop[kObjectPropertyKeyId] as? Int
      backgroundImageUrl = shop[kShopPropertyKeyBackgroundImageUrl] as? String
      name = shop[kShopPropertyKeyName] as? String
      profileImageUrl = shop[kShopPropertyKeyProfileImageUrl] as? String
      desc = shop[kObjectPropertyKeyDescription] as? String
      if let products = shop["products"] as? [[String: AnyObject]] {
        productsCount = products.count
      }
      if let tags = shop["tags"] as? [String] {
        self.tags = tags
      }
    }
  }
  
  override func getUrl() -> String {
    return "shops/\(id!)"
  }
  
  func tagString() -> String? {
    if let tags = tags {
      var tagString = String()
      for tag in tags {
        tagString += "#\(tag) "
      }
      return tagString
    }
    return nil
  }
}
