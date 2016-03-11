
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
  
  override func assignObject(data: AnyObject?) {
    if let shop = data as? [String: AnyObject] {
      print(data)
      id = shop[kObjectPropertyKeyId] as? Int
      backgroundImageUrl = shop[kShopPropertyKeyBackgroundImageUrl] as? String
      name = shop[kShopPropertyKeyName] as? String
      profileImageUrl = shop[kShopPropertyKeyProfileImageUrl] as? String
      desc = shop[kObjectPropertyKeyDescription] as? String
      if let products = shop["products"] as? [[String: AnyObject]] {
        productsCount = products.count
      }
    }
  }
  
  override func getUrl() -> String {
    return "shops/\(id!)"
  }
}
