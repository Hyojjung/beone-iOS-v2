
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
    if let data = data as? [String: AnyObject] {
      let shop = data[kNetworkResponseKeyData] != nil ? data[kNetworkResponseKeyData] : data
      if let shop = shop as? [String: AnyObject] {
        id = shop[kObjectPropertyKeyId] as? Int
        backgroundImageUrl = shop[kShopPropertyKeyBackgroundImageUrl] as? String
        name = shop[kShopPropertyKeyName] as? String
        profileImageUrl = shop[kShopPropertyKeyProfileImageUrl] as? String
        summary = shop[kShopPropertyKeyDescription] as? String
      }
    }
  }
  
  override func fetchUrl() -> String {
    return "shops/\(id!)"
  }
}
