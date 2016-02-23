
import UIKit

class Shop: BaseModel {
  private let kShopPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
  private let kShopPropertyKeyName = kObjectPropertyKeyName
  private let kShopPropertyKeyProfileImageUrl = "profileImageUrl"
  
  var backgroundImageUrl: String?
  var name: String?
  var profileImageUrl: String?
  var desc: String?
  
  override func assignObject(data: AnyObject?) {
    if let shop = data as? [String: AnyObject] {
      id = shop[kObjectPropertyKeyId] as? Int
      backgroundImageUrl = shop[kShopPropertyKeyBackgroundImageUrl] as? String
      name = shop[kShopPropertyKeyName] as? String
      profileImageUrl = shop[kShopPropertyKeyProfileImageUrl] as? String
      desc = shop[kObjectPropertyKeyDescription] as? String
    }
  }
  
  override func getUrl() -> String {
    return "shops/\(id!)"
  }
}
